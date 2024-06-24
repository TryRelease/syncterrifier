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

  def all(account_id:, **options)
    super(**options.merge(path: "#{account_id}/relationships"))
  end
end
