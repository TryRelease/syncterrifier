require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'hashie'
require 'uri'

require_relative 'collection'
require_relative 'client'

class Syncterrifier::Model
  class << self
    attr_reader :url, :associations, :scope_name, :required_params, :use_v1

    def uses_v1!
      @use_v1 = true
    end

    def endpoint(url)
      @url ||= begin
        url = url.to_s
        if url.match(/{{/)
          url.scan(/{{\w*}}/).each do |param|
            url.gsub(param, self.send(param.gsub(/[{}]/, '').to_sym))
          end
        else
          url
        end
      end
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
      path = options.delete(:path)
      base_url = options.delete(:base_url_override)
      api_override_key = options.delete(:api_key)

      uri = "#{base_url || url}#{path ? '/' + path : ''}#{options.keys.any? ? "?#{URI.encode_www_form(options)}" : ''}"

      response = client.get(uri, use_v1:, api_override_key:)
      if response.keys.include?('result')
        response = response['result']
      else
        response = response[(scope_name || url).to_s]
      end

      collection = response.map do |data|
        self.new(data)
      end

      limit = options[:limit] ? options[:limit].to_i : 100
      limit = 100 if limit > 100

      Syncterrifier::Collection.new(
        data:           collection,
        model_class:    self.class,
        path:           uri,
        pagination: !response.is_a?(Array) && response['next_page_token'] ? {
          next_page_token:  response['next_page_token'],
          limit:            limit,
        } : nil
      )
    end

    def find(id, **options)
      api_override_key = options.delete(:api_key)
      self.new(client.get("#{ url }/#{ id }", use_v1:, api_override_key:))
    end

    def validate_data!(data)
      # TODO: implement this or leave to the API to validate?
      # if required_params
      #   required_params.each do |name, type|
      #   end
      # end
    end

    def create(idempotency_key: nil, api_key: nil, **data)
      validate_data!(data)
      api_override_key = api_key

      self.new(client.post("#{ url }", data, idempotency_key: idempotency_key, use_v1:, api_override_key:))
    end
  end

  attr_reader :data, :path

  def initialize(data, relative_path: nil)
    @data = Hashie::Mash.new(data)
    @path = relative_path
  end

  def update(data, **options)
    api_override_key = options.delete(:api_key)
    # validate_data!(data)

    client.patch((update_path || uri), data, use_v1:, api_override_key:)
  end

  def destroy(**options)
    api_override_key = options.delete(:api_key)
    client.delete(delete_path || uri, use_v1:, api_override_key:)
  end

  def uri
    [(path || url), "#{ self.id }"].compact.join('/')
  end

  protected

  def delete_path; end
  def update_path; end

  def fetch_association(association_name, **options)
    association_class = "Paylocifier::#{ association_name.to_s.singularize.capitalize }".constantize
    association_path  = "#{ uri }/#{ association_name }"
    api_override_key  = options.delete(:api_key)

    collection = client.get(association_path, use_v1:, api_override_key:)[(scope_name || url).to_s].map do |data|
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
  def use_v1; self.class.use_v1; end
  def associations; self.class.associations; end

  private

  def method_missing(method, *args)
    return data.send(method, *args) if data.respond_to?(method)
    return association(method) if Array(associations).include?(method.to_s)

    super
  end
end
