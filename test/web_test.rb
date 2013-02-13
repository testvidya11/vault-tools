require 'helper'

# A fake web API frontend for use in tests.
class WebFake < Vault::Web
end

# Helper uses Rack's test mode to serve our fake web API frontend in tests.
module WebHelper
  include Rack::Test::Methods

  def app
    WebFake
  end
end

class WebTest < Vault::TestCase
  include WebHelper

  # A successful request causes a `web-20` log entry to be written.
  def test_head_status_check
    head '/'
    assert_match(/measure=true/, Scrolls.stream.string)
    assert_match(/at=web-20/, Scrolls.stream.string)
    assert_equal(200, last_response.status)
  end

  # A successful request causes `web-20` log entry to be written and `OK`
  # content is returned in the response body.
  def test_get_health_check
    get '/health'
    assert_match(/measure=true/, Scrolls.stream.string)
    assert_match(/at=web-20/, Scrolls.stream.string)
    assert_equal(200, last_response.status)
    assert_equal('OK', last_response.body)
  end

  # A validation error causes a `web-40` log entry to be written.
  def test_head_with_unknown_endpoint
    head '/unknown'
    assert_match(/measure=true/, Scrolls.stream.string)
    assert_match(/at=web-40/, Scrolls.stream.string)
    assert_equal(404, last_response.status)
  end

  # An internal server error causes a `web-50` log entry to be written.  A
  # traceback is also written to the response body to ease debugging.
  def test_error_logs_500
    get '/boom'
    assert_match(/measure=true/, Scrolls.stream.string)
    assert_match(/at=web-50/, Scrolls.stream.string)
    assert_match(/^RuntimeError: An expected unexpected error occurred.$/m,
                 last_response.body)
    assert_equal(500, last_response.status)
  end
end
