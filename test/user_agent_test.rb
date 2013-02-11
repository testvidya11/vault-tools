require 'helper'

class UserAgentTest < Vault::TestCase
  # UserAgent exposes the values provided during instantiation as attributes.
  def test_instantiate
    agent = Vault::UserAgent.new('username')
    assert_equal('username', agent.username)
    assert_equal({}, agent.detail)
  end

  # UserAgent exposes the values provided during instantiation as attributes.
  def test_instantiate_with_detail
    agent = Vault::UserAgent.new('username', 'roles' => ['read', 'write'],
                                 'not-before' => '2013-02-01T13:57:03Z',
                                 'not-on-or-after' => '2013-03-01T00:00:01Z')
    assert_equal('username', agent.username)
    assert_equal({'roles' => ['read', 'write'],
                  'not-before' => '2013-02-01T13:57:03Z',
                  'not-on-or-after' => '2013-03-01T00:00:01Z'},
                 agent.detail)
  end

  # UserAgent#encode converts a user agent to an OpenToken hash and
  # UserAgent.decode converts a hash back into an object instance.
  def test_encode_and_decode
    agent1 = Vault::UserAgent.new('username')
    agent2 = Vault::UserAgent.decode(agent1.encode())
    assert_equal('username', agent2.username)
    assert_equal({}, agent2.detail)
  end

  # UserAgent#encode correctly stores additional details.
  def test_encode_and_decode_with_detail
    agent1 = Vault::UserAgent.new('username', 'roles' => ['read', 'write'],
                                  'not-before' => '2013-02-01T13:57:03Z',
                                  'not-on-or-after' => '2013-03-01T00:00:01Z')
    agent2 = Vault::UserAgent.decode(agent1.encode())
    assert_equal('username', agent2.username)
    assert_equal({'roles' => ['read', 'write'],
                  'not-before' => '2013-02-01T13:57:03Z',
                  'not-on-or-after' => '2013-03-01T00:00:01Z'},
                 agent2.detail)
  end

  # UserAgent#encode and UserAgent#decode don't overwrite the global
  # OpenToken#password.
  def test_encode_and_decode_manage_opentoken_secret
    OpenToken.password = 'secret'
    Vault::UserAgent.opentoken_secret = 'secret-password!'
    agent = Vault::UserAgent.new('username')
    Vault::UserAgent.decode(agent.encode())
    assert_equal('secret', OpenToken.password)
    assert_equal('secret-password!', Vault::UserAgent.opentoken_secret)
  end

  # UserAgent#encode uses the OpenToken secret when it generates tokens.
  def test_encode_uses_opentoken_secret
    OpenToken.password = 'secret'
    Vault::UserAgent.opentoken_secret = 'secret-password!'
    agent = Vault::UserAgent.new('username')
    token = agent.encode()
    OpenToken.password = 'secret-password!'
    attributes = OpenToken.decode(token)
    assert_equal({'username' => 'username', 'detail' => '{}',
                  'not-before' => '2013-02-11T23:14:09Z',
                  'not-on-or-after' => '2013-02-11T23:19:09Z',
                  'renew-until' => '2013-02-12T11:14:09Z'},
                 attributes)
  end
end
