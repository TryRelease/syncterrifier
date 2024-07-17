require 'faraday'
require 'json'

class Syncterrifier::Client
  attr_reader :config

  def initialize
    @config = Syncterrifier.config
  end

  def post(url, data, idempotency_key: nil, use_v1: false)
    send_request(:post, url, data, idempotency_key: idempotency_key, use_v1: use_v1)
  end

  def put(url, data, use_v1: false)
    send_request(:put, url, data, use_v1: use_v1)
  end

  def patch(url, data, use_v1: false)
    send_request(:patch, url, data, use_v1: use_v1)
  end

  def get(url, use_v1: false)
    parse_response((use_v1 ? v1_connection : connection).get(url.to_s))
  end

  def delete(url, use_v1: false)
    parse_response((use_v1 ? v1_connection : connection).delete(url.to_s))
  end

  def send_request(method, url, data, idempotency_key: nil, use_v1: false)
    parse_response((use_v1 ? v1_connection : connection).send(method, url.to_s) do |req|
      req.body = data.to_json
      req.headers["Idempotency-Key"] = idempotency_key
    end)
  end

  private

  def connection
    @connection ||= Faraday.new(
      url:      config.host,
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ config.api_key }"
      }
    )
  end

  def v1_connection
    @v1_connection ||= Faraday.new(
      url:      config.host.gsub("v0", "v1"),
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ config.api_key }"
      }
    )
  end

  def parse_response(resp)
    if resp.status.between?(200, 299)
      data = resp.body
      if data.is_a?(String) && data.length > 0
        data = JSON.parse(resp.body)
      elsif data.is_a?(String) && data.length == 0
        return 'Success'
      end

      if data.is_a?(Array)
        data.map { |item| item.deep_transform_keys!(&:underscore) }
      else
        data.deep_transform_keys!(&:underscore)
      end
    elsif resp.status == 400
      body = JSON.parse(resp.body)
      raise "#{ resp.status }: #{body['title']}\n  => Detail: #{ body['detail'] }\n  => Type: #{body['type']}\n"
    else
      # {
      #   "code": "IDEMPOTENCY_INVALID_REUSE",
      #   "detail": "The request included an Idempotency-Key header which was already used for a different request: an Idempotency-Key must not be reused across different paths, methods or request payloads",
      #   "status": 422,
      #   "title": "Unprocessable Entity",
      #   "type": "https://dev.synctera.com/errors/unprocessable-entity"
      # }

      body = JSON.parse(resp.body)
      raise "#{ resp.status }: #{body['title']} - #{body['code']}\n  => Detail: #{ body['detail'] }\n  => Type: #{body['type']}\n"
    end
  end
end
