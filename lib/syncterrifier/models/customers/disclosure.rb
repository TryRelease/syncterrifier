# frozen_string_literal: true

require_relative "../../model"

<<-DOC
  Possible params:
    acknowledging_person_id - string (required for OWNER_CERTIFICATION)
    person_id - string (required if no business_id)
    business_id - string (required if no acknowledging_peron_id)
    disclosure_date - date (required)
    event_type - string (required) (DISPLAYED, VIEWED, ACKNOWLEDGED)
    metadata - hash (optional)
    type - string (required) (ACH_AUTHORIZATION, CARDHOLDER_AGREEMENT, E_SIGN, KYC_DATA_COLLECTION, PRIVACY_NOTICE, OWNER_CERTIFICATION, REG_CC, REG_DD, REG_E, TERMS_AND_CONDITIONS, SC_ACCOUNT_AGREEMENT, SC_SECURITY_AGREEMENT, SC_AUTO_PAYMENT)
DOC

class Syncterrifier::Disclosure < Syncterrifier::Model
  endpoint :disclosures

  required_params(
    disclosure_date: :datetime,
    event_type: :string,
    type: :string,
    person_id: [:string, { unless: :business_id }],
    business_id: [:string, { unless: :person_id }],
    version: :string
  )
end
