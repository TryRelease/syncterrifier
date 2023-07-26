require_relative '../../model'

<<-DOC
  Possible params:
    compliance_restrictions - array of strings (only LICENSED_CANNABIS supported)
    ein - string (9 digits in format XX-XXXXXXX)
    email - string
    entity_name - string
    formation_date - string (format YYYY-MM-DD)
    formation_state - string (2 letters eg: CA)
    is_customer - boolean (should be true for any personal/business with direct relationship to fintech)
    legal_address - address object
      address_line_1 - string (required)
      address_line_2 - string
      city - string
      country_code - string (Alpha-2) (required)
      postal_code - string
      state - string (ISO 3166-2)
    metadata - generic object
    phone_number - string (E.164 w/ country code eg: +13173319718)
    status - string - PROSPECT, ACTIVE, FROZEN, SANCTION, DISSOLVED, CANCELLED, SUSPENDED, MERGED, INACTIVE, CONVERTED (required)
    structure - string - CORPORATION, LLC, SOLE_PROPRIETORSHIP, PARTNERSHIP, NON_PROFIT, S_CORPORATION, OTHER
    tenant - string (id of tenant containing resource - used for multi-workspace fintechs)
    trade_names - array of strings
    website - string
DOC

class Syncterrifier::Business < Syncterrifier::Model
  endpoint :businesses

  required_params(
    is_customer: :boolean,
    status: [
      "PROSPECT",
      "ACTIVE",
      "FROZEN",
      "SANCTION",
      "DISSOLVED",
      "CANCELLED",
      "SUSPENDED",
      "MERGED",
      "INACTIVE",
      "CONVERTED"
    ]
  )

  def self.create(data, idempotency_key: nil)
    data[:status]       = 'ACTIVE'  if !data.has_key?(:status)
    data[:is_customer]  = true      if !data.has_key?(:is_customer)

    super(data, idempotency_key: idempotency_key)
  end
end
