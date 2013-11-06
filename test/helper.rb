require 'vault-test-tools'
require 'vault-tools'

ENV['RACK_ENV'] = 'test'

module LoggedDataHelper
  def logged_data
    Hash[Scrolls.stream.string.split(/\s+/).map {|p| p.split('=') }]
  end
end

module Honeybadger
  def self.exceptions
    @exceptions ||= []
  end

  def self.notify(exception, opts = {})
    self.exceptions << [exception, opts]
  end
end

module HoneybadgerHelper
  def setup
    super
    Honeybadger.exceptions.clear
  end
end

class Vault::TestCase
  include Vault::Test::EnvironmentHelpers
  include HoneybadgerHelper
end

Vault.setup
