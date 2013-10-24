require 'vault-test-tools'
require 'vault-tools'
ENV['RACK_ENV'] = 'test'
Vault.setup

class Vault::TestCase
  include Vault::Test::EnvironmentHelpers

  def logged_data
    Hash[Scrolls.stream.string.split(/\s+/).map {|p| p.split('=') }]
  end
end
