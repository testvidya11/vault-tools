require 'vault-test-tools'
require 'vault-tools'

ENV['RACK_ENV'] = 'test'

module LoggedDataHelper
  def logged_data
    Hash[Scrolls.stream.string.split(/\s+/).map {|p| p.split('=') }]
  end
end

Vault.setup
