require 'faraday'
require 'json'

class Syncterrifier::Client
  attr_reader :config

  def initialize
    @config = Syncterrifier.config
  end

  def post(url, data)
    send_request(:post, url, data)
  end

  def put(url, data)
    send_request(:put, url, data)
  end

  def patch(url, data)
    send_request(:patch, url, data)
  end

  def get(url)
    parse_response(connection.get(url.to_s))
  end

  def delete(url)
    parse_response(connection.delete(url.to_s))
  end

  def send_request(method, url, data)
    parse_response(connection.send(method, url.to_s) do |req|
      req.body = data.to_json
    end)
  end

  private

  def connection
    @connection = Faraday.new(
      url:      "",
      headers:  {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ token }"
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
      messages = JSON.parse(resp.body).map { |item| "\t - #{ item['message'] } #{ item['options'] }" }
      messages = messages.join("\n")
      raise "#{ resp.status }:\n\n#{ messages }"
    else
      raise "#{ resp.status } - #{ resp.reason_phrase }"
    end
  end
end
