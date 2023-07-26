require_relative '../../model'

<<-DOC
  Possible params:
    ACCOUNT_DEPOSITORY type
      access_status - string (ACTIVE, FROZEN)
      account_purpose - string
      account_type - string (SAVING, CHECKING, LINE_OF_CREDIT, CHARGE_SECURED)
      application_id - string
      currency - string (def: USD)
      exchange_rate_type - string (M, INTERBANK, CUST)
      iban - string
      is_account_pool - boolean
      metadata - generic object
      nickname - string
      status - string (ACCOUNT_NEVER_ACTIVE, ACCOUNT_NOT_DESIRED, ACTIVATED_NOT_DISBURSED, ACTIVE_OR_DISBURSED, APPLICATION_SUBMITTED, AWAITING_FIXING, CHARGED_OFF, CLOSED, DELINQUENT, FAILED_KYC, IN_CLOSING, RESTRICTED, SUSPENDED)
      swift_code - string
      tenant - string
      balance_ceiling - balance ceiling object
        balance - int64 (required)
        linked_account_id - string
        overflow_account_id - string (deprecated)
      balance_floor - balance floor object
        balance - int64 (required)
        linked_account_id - string
        overdraft_account_id - string (deprecated)
      fee_product_ids - array of strings
      interest_product_id - string
      note - string
      overdraft_limit - int64 (deprecated)
      spend_control_ids - array of strings
      spending_limits - spending limit object
        day - day object
          amount - int64
          transactions - int64
        description - string
        lifetime - lifetime object
          amount - int64
          transactions - int64
        month - month object
          amount - int64
          transactions - int64
        transaction - transaction object
          amount - int64
        week - week object
          amount - int64
          transactions - int64
      account_template_id - string (required if no account_type)
      relationships - array of objects
        business_id - string
        customer_id - string
        person_id - string
        relationship_type - string (PRIMARY_ACCOUNT_HOLDER, ACCOUNT_HOLDER, )

    ACCOUNT_LINE_OF_CREDIT type
    ACCOUNT_CHARGE_SECURED type
DOC

class Syncterrifier::Account < Syncterrifier::Model
  endpoint :accounts

  def available_balance
    balance = balances.find { |balance| balance.type == 'AVAILABLE_BALANCE' }
    balance.balance if balance
  end

  def account_balance
    balance = balances.find { |balance| balance.type == 'ACCOUNT_BALANCE' }
    balance.balance if balance
  end

  def accrued_interest_mtd
    if account_type != 'LINE_OF_CREDIT'
      balance = balances.find { |balance| balance.type == 'ACCRUED_INTEREST_MTD' }
      balance.balance if balance
    end
  end
end
