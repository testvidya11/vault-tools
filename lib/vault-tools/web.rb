require 'vault-tools/log'

module Vault
  class Web < Sinatra::Base
    def self.route(verb, action, *)
      condition { @action = action }
      super
    end

    before do
      @start_request = Time.now
    end

    after do
      Log.count_status(response.status)
      Log.time(@action, Time.now - @start_request)
    end

    # Health check on HEAD
    head('/')      { status(200) }

    # Trigger a 500 to test live monitoring and paging
    head('/boom')  { status(500) }

    # Can do more than the head request
    get('/health') { [200, 'OK'] }
  end
end
