class Syncterrifier::Wire < Syncterrifier::Model
  endpoint :wires

  required_params(
    amount: Integer, # in cents (USD)
    currency: String,
    customer_id: Integer, # sender
    bank_message: String, # message to the bank -- optional
    metadata: Hash, # optional
    originating_account_id: Integer, # sender,
    receiving_account_id: Integer, # receiver
    recipient_message: String, # message to the recipient -- required
  )

  def self.create(idempotency_key: nil, **data)
    data[:currency] = 'USD' if !data.has_key?(:currency)

    super(idempotency_key: idempotency_key, **data)
  end

  def cancel!
    update(status: 'CANCELED')
  end
end
