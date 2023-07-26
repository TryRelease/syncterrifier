require_relative '../../model'

<<-DOC
  Possible params:
    BENEFICIAL_OWNER_OF
      additional_data - additional data object (required)
        percent_ownership - double (required eg: 35.75)
      from_person_id - string (required)
      metadata - generic object
      relationship_type - string (required)
        BENEFICIAL_OWNER_OF
        MANAGING_PERSON_OF
        OWNER_OF
        PAYER_PAYEE
      tenant - string
      to_business_id - string (required)
    MANAGING_PERSON_OF
      additional_data - additional data object (required)
        title - string (required - OFFICER, DIRECTOR, FOUNDER)
      from_person_id - string (required)
      metadata - generic object
      relationship_type - string (required)
        BENEFICIAL_OWNER_OF
        MANAGING_PERSON_OF
        OWNER_OF
        PAYER_PAYEE
      tenant - string
      to_business_id - string (required)
    OWNER_OF
      additional_data - additional data object (required)
        percent_ownership - double (required eg: 35.75)
      from_business_id - string (required)
      metadata - generic object
      relationship_type - string (required)
        BENEFICIAL_OWNER_OF
        MANAGING_PERSON_OF
        OWNER_OF
        PAYER_PAYEE
      tenant - string
      to_business_id - string (required)
    PAYER_PAYEE
      additional_data - additional data object (required)
        transfer_type - string (required - DEBIT, CREDIT, DEBIT_OR_CREDIT)
      from_person_id - string
      from_business_id - string
      metadata - generic object
      relationship_type - string (required)
        BENEFICIAL_OWNER_OF
        MANAGING_PERSON_OF
        OWNER_OF
        PAYER_PAYEE
      tenant - string
      to_person_id - string
      to_business_id - string
DOC

class Syncterrifier::Relationship < Syncterrifier::Model
  endpoint :relationships
end
