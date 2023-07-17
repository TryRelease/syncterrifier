require 'active_support/inflector'

require_relative 'client'

class Syncterrifier::Collection
  include Enumerable

  class NotFound < StandardError; end

  attr_reader :data, :model_class, :path, :create_method

  def initialize(data: [], model_class: nil, path: nil)
    @data           = data
    @model_class    = model_class || @data.first&.class || raise(ArgumentError.new('Syncterrifier::Collection initialization requries model_class if data is empty'))
    @path           = path
  end

  def all
    @data ||= client.get(path).map do |data|
      model_class.new(data, relative_path: path)
    end
  end

  def find(id)
    if data
      data.find { |item| item.id.to_s === id.to_s }
    else
      model_class.new(client.get("#{ path }/#{ id }"), relative_path: path)
    end
  end

  def find!(id)
    find(id) || raise(NotFound.new("Couldn't find record with id #{ id }"))
  end

  def create(data)
    data.deep_transform_keys! { |x| x.to_s.camelize(:lower) }

    url = self.path
    if model_class == Syncterrifier::Deduction
      data = { deduction: data }
      data[:deduction][:employeeId] = path.gsub('employees/', '').to_i
      data[:deduction][:companyNumber] = Syncterrifier.config.company_id
      url = 'deduction'
    end

    resp = client.send(model_class.create_verb, url, data)

    if resp.is_a?(String)
      resp
    else
      model_class.new(resp, relative_path: url)
    end
  end

  private

  def method_missing(method, *args, &block)
    if [].respond_to?(method)
      all if !data
      return data.send(method, *args, &block)
    end
    super
  end

  def client
    @client ||= Syncterrifier::Client.new
  end
end
