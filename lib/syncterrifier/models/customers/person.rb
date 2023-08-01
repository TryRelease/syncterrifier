require_relative '../../model'

<<-DOC
  Possible params:
    ban_status - ALLOWED (def), SUSPENDED, BANNED
    chosen_name - string
    dob - date string (YYYY-MM-DD)
    email - string
    first_name - string
    is_customer - true/false (should be true for everyone? - required)
    last_name - string
    legal_address - address object
      address_line_1 - string (required)
      address_line_2 - string
      city - string
      country_code - string (Alpha-2) (required)
      postal_code - string
      state - string (ISO 3166-2)
    metadata - generic object
    middle_name - string
    phone_number - string (E.164 w/ country code eg: +13173319718)
    shipping_address - same as legal_address
    ssn - string (full SSN w/ hyphens eg: 123-45-6789)
    status - ACTIVE (def), DECEASED, DENIED, DORMANT, ESCHEAT, FROZEN, INACTIVE, PROSPECT, SANCTION (required)
    tenant - string (id of tenant containing resource - used for multi-workspace fintechs)
    personal_ids - array of personal idetifier objects
      id_type - string (ITIN, PASSPORT_NUMBER, SIN, SSN) (required)
      identifier - string (format depends on type) (required)
      country_code - string (ISO 3166-1 Alpha-2)
    note - string (required when ban_status is SUSPENDED)
DOC

class Syncterrifier::Person < Syncterrifier::Model
  endpoint :persons

  required_params(
    is_customer: :boolean,
    status: [
      'ACTIVE',
      'DECEASED',
      'DENIED',
      'DORMANT',
      'ESCHEAT',
      'FROZEN',
      'INACTIVE',
      'PROSPECT',
      'SANCTION'
    ]
  )

  def self.create(idempotency_key: nil, **data)
    data[:status] = 'ACTIVE' if !data.has_key?(:status)
    data[:is_customer] = true if !data.has_key?(:is_customer)

    super(idempotency_key: idempotency_key, **data)
  end
end
