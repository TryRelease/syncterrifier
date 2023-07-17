RSpec.describe Syncterrifier do
  it 'has a version number' do
    expect(Syncterrifier::VERSION).not_to be nil
  end

  it 'is configurable' do
    Syncterrifier.configure do |config|
      config.api_key = '1234567'
    end

    expect(Syncterrifier.config.api_key).to eq('1234567')
  end
end
