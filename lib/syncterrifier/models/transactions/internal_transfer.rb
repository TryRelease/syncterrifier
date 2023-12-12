require_relative '../../model'

<<-DOC
  Possible params:
    amount - number (in cents)
    capture_mode - string (required) (IMMEDIATE, MANUAL)
    currency - string (required) (USD, EUR, GBP, etc.)
    expires_at - datetime - only need when MANUAL captrue mode
    final_customer_id - string - The customer id of the international customer that receives the final remittance transfer (required for remittance payments).
    memo - string - short note to recipient
    metadata - hash - any data you want to store
    originating_account_alias - string - alias representing a GL account to debit. This is alternative to specifying by account id
    originating_account_customer_id - string - customer id of the account to debit
    originating_account_id - string uuid (required)
    receiving_account_alias - string - alias representing a GL account to credit. This is alternative to specifying by account id
    receiving_account_customer_id - string - customer id of the account to credit
    receiving_account_id - string uuid (required)
    tenant - string - tenant id
    tenant - string (required) [
      ACCOUNT_TO_ACCOUNT
      ACCOUNT_TO_ACCOUNT_SWEEP
      ACH_CREDIT_SWEEP
      ACH_DEBIT_SWEEP
      ACH_FLOAT_TRANSFER
      ACH_INCOMING_CREDIT_SWEEP
      ACH_INCOMING_DEBIT_SWEEP
      ACH_INCOMING_RETURN_CREDIT_SWEEP
      ACH_INCOMING_RETURN_DEBIT_SWEEP
      ACH_OUTGOING_CREDIT_SWEEP
      ACH_OUTGOING_DEBIT_SWEEP
      ACH_OUTGOING_RETURN_CREDIT_SWEEP
      ACH_OUTGOING_RETURN_DEBIT_SWEEP
      ACH_SWEEP
      CARD_CHARGEBACK
      CARD_CHARGEBACK_WRITEOFF
      CARD_PROVISIONAL_CREDIT
      CASHBACK
      CASHBACK_SWEEP
      CREDIT_MEMO
      DOMESTIC_WIRE_INCOMING_RETURN_SWEEP
      DOMESTIC_WIRE_INCOMING_SWEEP
      DOMESTIC_WIRE_OUTGOING_RETURN_SWEEP
      DOMESTIC_WIRE_OUTGOING_SWEEP
      EFT_CA_INCOMING_CREDIT_RETURN_SWEEP
      EFT_CA_INCOMING_CREDIT_SWEEP
      EFT_CA_INCOMING_DEBIT_RETURN_SWEEP
      EFT_CA_INCOMING_DEBIT_SWEEP
      EFT_CA_OUTGOING_CREDIT_RETURN_SWEEP
      EFT_CA_OUTGOING_CREDIT_SWEEP
      EFT_CA_OUTGOING_DEBIT_RETURN_SWEEP
      EFT_CA_OUTGOING_DEBIT_SWEEP
      FEE
      FEE_SWEEP
      FORCE_PAYMENT
      INCOMING_WIRE
      INCOMING_WIRE_SWEEP
      INTEREST_CHARGED_SWEEP
      INTEREST_PAYOUT
      INTEREST_PAYOUT_SWEEP
      INTERNATIONAL_WIRE_OUTGOING_SWEEP
      INVOICE
      LOAN_DISBURSEMENT
      LOAN_FUNDING
      MANUAL_ADJUSTMENT
      MANUAL_ADJUSTMENT_REVERSAL
      MANUAL_ADJUSTMENT_SWEEP
      MANUAL_AFT_SWEEP
      MANUAL_CARD_SWEEP
      MANUAL_CASH_DEPOSIT_SWEEP
      MANUAL_CASH_ORDER_SWEEP
      MANUAL_CHECK_SWEEP
      MANUAL_OCT_SWEEP
      MANUAL_WIRE_SWEEP
      MASTERCARD_GROSS_SWEEP
      MASTERCARD_INTERCHANGE_SWEEP
      MASTERCARD_NET_SWEEP
      MOBILE_DEPOSIT_RETURN_SWEEP
      MOBILE_DEPOSIT_SWEEP
      NETWORK_ADJUSTMENT_SWEEP
      NETWORK_CHARGEBACK_SWEEP
      OUTGOING_INTERNATIONAL_REMITTANCE
      OUTGOING_INTERNATIONAL_REMITTANCE_REVERSAL
      PROMOTIONAL_CREDIT
      PROMOTIONAL_CREDIT_REVERSAL
      PROMOTIONAL_CREDIT_SWEEP
      PULSE_GROSS_SWEEP
      PULSE_INTERCHANGE_SWEEP
      SECURITY_ACCOUNT_PAYMENT
      SIGN_UP_BONUS
      SUBSCRIPTION_FEE
      TRANSFER_FEE
      TRANSFER_FEE_REVERSAL
      VISA_GROSS_SWEEP
      VISA_INTERCHANGE_SWEEP
      VISA_NET_SWEEP
      WIRE_SETTLEMENT_CREDIT
      WIRE_SETTLEMENT_DEBIT
    ]
DOC

class Syncterrifier::InternalTransfer < Syncterrifier::Model
  endpoint 'transactions/internal_transfer'
end
