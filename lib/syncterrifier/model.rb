require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'hashie'

require_relative 'collection'
require_relative 'client'

class Syncterrifier::Model
  # private_class_method :new

  class << self
    attr_reader :url, :associations

    def endpoint(url)
      @url ||= url
    end

    def has_many(association)
      @associations ||= []
      @associations << association.to_s
    end

    def associations
      @associations || []
    end

    def create_method(method_name)
      @create_verb = method_name
    end

    def create_verb
      @create_verb || :post
    end

    def legacy!
      @legacy = true
    end

    def client
      @client ||= Syncterrifier::Client.new
    end

    def all
      collection = client.get(url).map do |data|
        self.new(data)
      end

      Syncterrifier::Collection.new(
        data:           collection,
        model_class:    self.class,
        path:           url,
      )
    end

    def find(id)
      self.new(client.get("#{ url }/#{ id }"))
    end

    def create(data)
      data.deep_transform_keys! { |x| x.to_s.camelize(:lower) }

      self.new(client.post("#{ url }", data))
    end
  end

  attr_reader :data, :path

  def initialize(data, relative_path: nil)
    @data = Hashie::Mash.new(data)
    @path = relative_path
  end

  def update(data)
  end

  def destroy
    client.delete(delete_path || uri)
  end

  def uri
    [(path || url), "#{ self.id }"].compact.join('/')
  end

  protected

  def delete_path; end

  def fetch_association(association_name)
    association_class = "Paylocifier::#{ association_name.to_s.singularize.capitalize }".constantize
    association_path  = "#{ uri }/#{ association_name }"

    collection = client.get(association_path).map do |data|
      association_class.new(data)
    end

    Syncterrifier::Collection.new(
      data:         collection,
      model_class:  association_class,
      path:         association_path
    )
  end

  def association(association_name)
    ivar = :"@#{ association_name }"
    instance_variable_get(ivar) || instance_variable_set(ivar, begin
      association_class = "Syncterrifier::#{ association_name.to_s.singularize.capitalize }".constantize
      association_path  = "#{ uri }/#{ association_name }"

      Syncterrifier::Collection.new(
        data:         nil,
        model_class:  association_class,
        path:         association_path
      )
    end)
  end

  def client; self.class.client; end
  def url; self.class.url; end
  def associations; self.class.associations; end

  private

  def method_missing(method, *args)
    return data.send(method, *args)   if data.respond_to?(method)
    return association(method) if Array(associations).include?(method.to_s)

    super
  end
end
