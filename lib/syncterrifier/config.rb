class Syncterrifier::Config
  attr_accessor :api_key, :host

  def initialize(api_key: nil, host: "https://api.synctera.com/v0/")
    @api_key  = api_key
    @host     = host
  end
end

