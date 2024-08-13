<<-DOC
  product_type - FEE or INTEREST
  FEE ->
    amount - Integer in cents, required
    currency - String, required
    fee_type - ACH_FEE, ANNUAL_FEE, ATM_WITHDRAWAL_FEE, MONTHLY_FEE, OVERDRAFT_FEE, WIRE_FEE
  INTEREST ->
    accrual_payout_schedule - MONTHLY or NONE
    calculation_method - COMPOUNDED_DAILY or COMPOUNDED_MONTHLY
    description - String, optional
    rates ->
      accrual_period - DAILY or MONTHLY
      rate - Integer - Rate in basis points. E.g. 5 represents 0.05%
      valid_from - Date - required
      valid_to - Date - optional
DOC

class Syncterrifier::Product < Syncterrifier::Model
  endpoint 'accounts/products'
end
