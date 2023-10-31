# frozen_string_literal: true

require_relative "syncterrifier/version"

require "syncterrifier/config"
require "syncterrifier/client"

require "syncterrifier/model"
require "syncterrifier/collection"

require "syncterrifier/models/accounts/account"

require "syncterrifier/models/customers/person"
require "syncterrifier/models/customers/business"
require "syncterrifier/models/customers/relationship"
require "syncterrifier/models/customers/disclosure"

require "syncterrifier/models/verifications/verification"

module Syncterrifier
  class Error < StandardError; end

  def self.configure
    yield config
  end

  def self.config
    @@config ||= Syncterrifier::Config.new
  end
end
