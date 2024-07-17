require_relative '../../../uuid_validator.rb'

class Syncterrifier::FdxAuthRequest < Syncterrifier::Model
  endpoint :fdx_auth_requests

  def self.authorize(customer_id:, auth_request_id:, status:)
    validate_data!(customer_id:, auth_request_id:, status:)
    self.new(client.post("fdx_auth_requests/authorize", data))
  end

  def self.validate_data!(customer_id:, auth_request_id:, status:)
    raise "customer_id (UUID) is required" unless UuidValidator.validate(customer_id)
    raise "auth_request_id (string) is required" unless auth_request_id.is_a?(String) && auth_request_id.length > 0
    raise "status is required" unless status.is_a?(String) && status.length > 0
    raise "status must be DENIED/GRANTED/ERROR" unless %w[DENIED GRANTED ERROR].include?(status)
  end
end
