require_relative "../../model"
require_relative "../transactions/transaction"

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
    balance = balances.find { |balance| balance.type == "AVAILABLE_BALANCE" }
    balance.balance if balance
  end

  def account_balance
    balance = balances.find { |balance| balance.type == "ACCOUNT_BALANCE" }
    balance.balance if balance
  end

  def accrued_interest_mtd
    return unless account_type != "LINE_OF_CREDIT"

    balance = balances.find { |balance| balance.type == "ACCRUED_INTEREST_MTD" }
    balance.balance if balance
  end

  def self.templates
    Hashie::Mash.new(client.get("#{url}/templates"))
  end

  def statements
    Syncterrifier::Statement.all(base_url_override: "accounts/#{id}", path: "statements")
  end

  # include_child_transactions = boolean
  # status = [string, string]
  # from_date = 2023-10-01
  # to_date = 2023-10-01
  # type = string
  # page_token = string
  # account_id = string
  # card_id = string
  # reference_id = string
  # limit = integer 100 or less
  # subtype = string

  def pending_transactions(**params)
    Syncterrifier::Transaction.pending(**(params.merge(account_id: id)))
  end

  def posted_transactions(**params)
    Syncterrifier::Transaction.posted(**(params.merge(account_id: id)))
  end

  def initiate_closure
    # https://api-sandbox.synctera.com/v0/accounts/{account_id}/initiate_closure
    # destination_id - string - external account

    # payment_method
    # value="ACH"
    # value="EXTERNAL"
    # value="INTERNAL_TRANSFER_TO_CUSTOMER_ACCOUNT"
    # value="INTERNAL_TRANSFER_TO_INTERNAL_ACCOUNT"

    # reason
    # BANK_REQUEST_FRAUD
    # BANK_REQUEST_INACTIVITY
    # BANK_REQUEST_REDEEMED_OR_REINSTATED_REPOSSESSION
    # BANK_REQUEST_REGULATORY_REASONS
    # CUSTOMER_REQUEST_CREDIT_CARD_LOST_OR_STOLEN
    # CUSTOMER_REQUEST_REFINANCE
    # CUSTOMER_REQUEST_TRANSFER
    # CUSTOMER_REQUEST_VOLUNTARILY_SURRENDERED
    # PROGRAM_SHUT_DOWN_BANK
    # PROGRAM_SHUT_DOWN_FINTECH

    # reason_details
  end
end
