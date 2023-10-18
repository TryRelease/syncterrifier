require_relative '../../model'

<<-DOC
  Possible params:
    customer_ip_address
    document_id

    customer_consent - boolean (required)
    person_id - string (required if no business_id)
    business_id - string (required if no person_id)
DOC

class Syncterrifier::Verification < Syncterrifier::Model
  endpoint :verifications

  required_params(
    customer_consent: :boolean,
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

  def self.verify(idempotency_key: nil, **data)
    Hashie::Mash.new(client.post("#{ url }/verify", data, idempotency_key: idempotency_key))
  end
end
