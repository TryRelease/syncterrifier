require_relative "../../model"

<<-DOC
  business_id - string (required if no customer_id)
  customer_id - string (required if no business_id)
  customer_type - string (required) [PERSON, BUSINESS]
  vendor - string (required) [FINICITY, PLAID]
  vendor_access_token - string (required) (for plaid, access_token)
  vendor_account_ids - array of strings (required) (for plaid, account_ids)
  vendor_customer_id - string (required) (for plaid, user_id)
  verify_owner - boolean - should synctera try to verify external owner matches internal owner?
DOC

class Syncterrifier::ExternalAccount < Syncterrifier::Model
  endpoint 'external_accounts'

  def self.add_vendor_account(idempotency_key: nil, **data)
    Hashie::Mash.new(client.post("#{url}/add_vendor_accounts", data, idempotency_key: idempotency_key))
  end
end
