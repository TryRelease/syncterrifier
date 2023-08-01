require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'hashie'
require 'uri'

require_relative 'collection'
require_relative 'client'

class Syncterrifier::Model
  # private_class_method :new

  class << self
    attr_reader :url, :associations, :scope_name, :required_params

    def endpoint(url)
      @url ||= url
    end

    def required_params(params)
      @required_params = params
    end

    def scope(scope_name)
      @scope_name ||= scope_name
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

    def all(**options)
      uri = "#{url}#{options.keys.any? ? "?#{URI.encode_www_form(options)}" : ''}"

      collection = client.get(uri)[(scope_name || url).to_s].map do |data|
        self.new(data)
      end

      Syncterrifier::Collection.new(
        data:           collection,
        model_class:    self.class,
        path:           uri,
      )
    end

    def find(id)
      self.new(client.get("#{ url }/#{ id }"))
    end

    def validate_data!(data)
      # TODO: implement this or leave to the API to validate?
      # if required_params
      #   required_params.each do |name, type|
      #   end
      # end
    end

    def create(idempotency_key: nil, **data)
      validate_data!(data)

      self.new(client.post("#{ url }", data, idempotency_key: idempotency_key))
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

    collection = client.get(association_path)[(scope_name || url).to_s].map do |data|
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
    return data.send(method, *args) if data.respond_to?(method)
    return association(method) if Array(associations).include?(method.to_s)

    super
  end
end
