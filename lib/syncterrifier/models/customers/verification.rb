require_relative '../../model'

<<-DOC
  Possible params:
    business_id - string
    metadata - generic object
    person_id - string
    result - string (UNVERIFIED, PENDING, PROVISIONAL, ACCEPTED, REVIEW, VENDOR_ERROR, REJECTED)
    vendor_info - json or xml
    verification_time - date-time (required)
    verification_type - string (required) - IDENTITY, WATCHLIST, RELATED_ENTITIES, MANUAL_REVIEW, LICENSE
DOC

class Syncterrifier::Verification < Syncterrifier::Model
  endpoint :verifications
end
