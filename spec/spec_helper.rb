# frozen_string_literal: true

require "syncterrifier"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def configure!
  Syncterrifier.configure do |config|
    config.api_key = '12345678'
  end
end

RSpec::Matchers.define :have_many do |association|
  match do |model|
    model.send(:associations).include?(association.to_s)
  end
end
