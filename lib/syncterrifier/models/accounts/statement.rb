require_relative "../../model"

class Syncterrifier::Statement < Syncterrifier::Model
  endpoint :statements

  def transactions
    Syncterrifier::Transaction.all(base_url_override: "statements/#{id}", path: "transactions")
  end
end
