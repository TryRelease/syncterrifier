class Syncterrifier::ACH < Syncterrifier::Model
  endpoint :ach

  required_params(
    amount: Integer,
    # company_entry_description: String,
    # company_name: String,
    currency: String,
    customer_id: Integer,
    dc_sign: String, # debit is transfer into originator, credit is transfer out of originator
    # effective_date: String,
    # external_data: Hash, # metadata
    # final_customer_id: String, # ID of the international customer that receives the final remittance transfer (required for OFAC enabled payments)
    # hold: Hash, # amount, duration
    # is_same_day: Boolean,
    # memo: String,
    originating_account_id: String,
    receiving_account_id: String,
    # reference_info: String, # Will be sent to the ACH network and maps to Addenda record 05 - the recipient bank will receive this info
    # risk: Hash, # client_ip
    # sec_code: String, # WEB, CCD
  )

  def self.create(idempotency_key: nil, **data)
    data[:currency] = 'USD' if !data.has_key?(:currency)

    super(idempotency_key: idempotency_key, **data)
  end
end
