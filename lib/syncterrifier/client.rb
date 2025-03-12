require 'faraday'
require 'json'

class Syncterrifier::Client
  attr_reader :config

  def initialize
    @config = Syncterrifier.config
  end

  def post(url, data, idempotency_key: nil, use_v1: false, api_override_key: nil)
    send_request(:post, url, data, idempotency_key: idempotency_key, use_v1: use_v1)
  end

  def put(url, data, use_v1: false, api_override_key: nil)
    send_request(:put, url, data, use_v1: use_v1, api_override_key: nil)
  end

  def patch(url, data, use_v1: false, api_override_key: nil)
    send_request(:patch, url, data, use_v1: use_v1, api_override_key: nil)
  end

  def get(url, use_v1: false, api_override_key: nil)
    parse_response((use_v1 ? v1_connection(api_override_key:) : connection(api_override_key:)).get(url.to_s))
  end

  def get_file(url, use_v1: false, api_override_key: nil)
    (use_v1 ? v1_connection(api_override_key:) : connection(api_override_key:)).get(url.to_s).body
  end

  def delete(url, use_v1: false, api_override_key: nil)
    parse_response((use_v1 ? v1_connection(api_override_key:) : connection(api_override_key:)).delete(url.to_s))
  end

  def send_request(method, url, data, idempotency_key: nil, use_v1: false, api_override_key: nil)
    parse_response((use_v1 ? v1_connection(api_override_key:) : connection(api_override_key:)).send(method, url.to_s) do |req|
      req.body = data.to_json
      req.headers["Idempotency-Key"] = idempotency_key
    end)
  end

  private

  def connection(api_override_key: nil)
    Faraday.new(
      url:      config.host,
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ api_override_key || config.api_key }"
      }
    )
  end

  def v1_connection(api_override_key: nil)
    Faraday.new(
      url:      config.host.gsub("v0", "v1"),
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ api_override_key || config.api_key }"
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

      puts resp.body

      raise "#{ resp.status }: #{body['title']}\n  => Detail: #{ body['detail'] }\n  => Type: #{body['type']}\n"
    elsif resp.status == 401
      raise "#{ resp.status }: Unauthorized\n"
    else
      # {
      #   "code": "IDEMPOTENCY_INVALID_REUSE",
      #   "detail": "The request included an Idempotency-Key header which was already used for a different request: an Idempotency-Key must not be reused across different paths, methods or request payloads",
      #   "status": 422,
      #   "title": "Unprocessable Entity",
      #   "type": "https://dev.synctera.com/errors/unprocessable-entity"
      # }

      puts resp.body

      body = JSON.parse(resp.body)

      raise "#{ resp.status }: #{body['title']} - #{body['code']}\n  => Detail: #{ body['detail'] }\n  => Type: #{body['type']}\n"
    end
  end
end
