require_relative "../../model"
<<-DOC
  Possible params:
    account_id - string (required)
    business_id - string -- customer must be assigned to activate, but you can issue to a bsuiness
    card_product_id - string (required)
    customer_id - string (required if activating)
    emboss_name - string (defaults to customer first/last name) (supports A-Z, a-z, 0-9, space, period, comma, forward slash, hyphen, ampersand, single quote)
    metadata - object
    reissue_reason - string (EXPIRATION, LOST, STOLEN, DAMAGED, VIRTUAL_TO_PHYSICAL, PRODUCT_CHANGE, APPEARANCE)
    reissued_from_id - string (specify card replaced if reissuing)
    type - string (DEBIT, PREPAID)
    form - string (VIRTUAL, PHYSICAL)

    # WHEN PHYSICAL
    card_image_id - string (id of custom image if physical)
    shipping - (required if physical)
      address - address object
        address_line_1 - string (required)
        address_line_2 - string
        city - string (required)
        country_code - string (ISO 3166-1 alpha-2 code) (required)
        postal_code - string (required)
        state - string (required)
      care_of_line - string
      is_expedited_fulfillment - boolean
      method - string (LOCAL_MAIL, LOCAL_PRIORITY, OVERNIGHT, TWO_DAY, INTERNATIONAL, INTERNATIONAL_GROUND, INTERNATION_PRIORITY, )
      phone_number - string
      recipient_name - object
        first_name - string (required)
        last_name - string (required)
        middle_name - string
DOC

class Syncterrifier::Card < Syncterrifier::Model
  endpoint :cards

  def self.activate(activation_code:, customer_id:)
    response = client.post('cards/activate', {
      activation_code:,
      customer_id:,
    })

    self.new(response)
  end
end
