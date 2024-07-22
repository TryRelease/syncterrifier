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

class Syncterrifier::AccountRelationship < Syncterrifier::Model
  endpoint 'accounts'

  scope 'relationships'

  def self.all(account_id:, **options)
    super(**options.except(:account_id).merge(path: "#{account_id}/relationships"))
  end

  def self.create(account_id:, idempotency_key: nil, **data)
    self.new(client.post("accounts/#{ account_id }/relationships", data, idempotency_key: idempotency_key))
  end

  def destroy
    client.delete("accounts/#{ account_id }/relationships/#{ id }")
  end

  def update(data)
    client.put("accounts/#{ account_id }/relationships/#{ id }", data, use_v1: false)
  end
end
