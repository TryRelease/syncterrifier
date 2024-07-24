require_relative '../../../uuid_validator.rb'

class Syncterrifier::FdxAuthRequest < Syncterrifier::Model
  endpoint :fdx_auth_requests

  uses_v1!

  def self.authorize(customer_id: nil, auth_request_id:, status:, business_id: nil)
    validate_data!(customer_id:, auth_request_id:, status:, business_id:)
    params = {
      auth_request_id: auth_request_id,
      status: status
    }
    params[:customer_id] = customer_id if customer_id
    params[:business_id] = business_id if business_id

    self.new(client.post("fdx_auth_requests/authorize", params, use_v1: true))
  end

  def self.validate_data!(customer_id: nil, auth_request_id:, status:, business_id: nil)
    if customer_id && !UuidValidator.validate(customer_id)
      raise "customer_id (UUID) is required"
    end
    if business_id && !UuidValidator.validate(business_id)
      raise "business_id (UUID) is required"
    end
    if !business_id && !customer_id
      raise "business_id or customer_id is required"
    end
    raise "auth_request_id (string) is required" unless auth_request_id.is_a?(String) && auth_request_id.length > 0
    raise "status is required" unless status.is_a?(String) && status.length > 0
    raise "status must be DENIED/GRANTED/ERROR" unless %w[DENIED GRANTED ERROR].include?(status)
  end
end
