# frozen_string_literal: true

require_relative "syncterrifier/version"

require 'syncterrifier/config'
require 'syncterrifier/client'

require 'syncterrifier/model'
require 'syncterrifier/collection'
require 'syncterrifier/models/person'

module Syncterrifier
  class Error < StandardError; end

  def self.configure
    yield config
  end

  def self.config
    @@config ||= Syncterrifier::Config.new
  end
end
