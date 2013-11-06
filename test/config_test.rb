require 'helper'
require 'minitest/mock'

class ConfigTest < Vault::TestCase
  include Vault::Test::EnvironmentHelpers

  # Vault::Config.remote_env uses the Heroku API to read config vars from
  # other apps.
  def test_remote_env
    api_mock = MiniTest::Mock.new
    api_response = OpenStruct.new(body: {'DATABASE_URL' => 'postgres:///foo'})
    Heroku::API.stub(:new, api_mock) do
      api_mock.expect(:get_config_vars, api_response, ['app'])
      assert_equal('postgres:///foo',
                   Vault::Config.remote_env('app', 'DATABASE_URL'))
    end
  end

  # Vault::Config.env returns the value matching the specified environment
  # variable name.
  def test_env
    set_env('VALUE', 'value')
    assert_equal(Vault::Config.env('VALUE'), 'value')
  end

  # Vault::Config.env return nil if an unknown environment variable is
  # requested.
  def test_env_with_unknown_name
    assert_equal(Vault::Config.env('UNKNOWN'), nil)
  end

  # Vault::Config.env! returns the value matching the specified environment
  # variable name.
  def test_env!
    set_env('VALUE', 'value')
    assert_equal(Vault::Config.env!('VALUE'), 'value')
  end

  # Vault::Config.env! raises a RuntimeError if an unknown environment
  # variable is requested.
  def test_env_with_unknown_name!
    error = assert_raises RuntimeError do
      Vault::Config.env!('UNKNOWN')
    end
    assert_equal(error.message, 'missing UNKNOWN')
  end

  # Vault::Config.production? is true when RACK_ENV=production.
  def test_production_mode
    set_env 'RACK_ENV', nil
    refute Vault::Config.production?
    set_env 'RACK_ENV', 'production'
    assert Vault::Config.production?
  end

  # Vault::Config.test? is true when RACK_ENV=test.
  def test_test_mode
    set_env 'RACK_ENV', nil
    refute Vault::Config.test?
    set_env 'RACK_ENV', 'test'
    assert Vault::Config.test?
  end

  # Returns DATABASE_URL with no params.
  def test_database_url
    set_env 'DATABASE_URL', "postgres:///foo"
    assert_equal(Vault::Config.database_url, 'postgres:///foo')
  end

  # Returns #{kind}_DATABASE_URL with one param
  def test_database_url_takes_and_capitalizes_params
    set_env 'FOO_DATABASE_URL', "postgres:///foo"
    assert_equal(Vault::Config.database_url('foo'), 'postgres:///foo')
  end

  # Vault::Config.database_url raises a RuntimeError if no DATABASE_URL
  # environment variables is defined.
  def test_database_url_raises_when_not_found
    assert_raises RuntimeError do
      Vault::Config.database_url('foo')
    end
  end

  # Vault::Config.app_name returns the value of the APP_NAME environment
  # variable.
  def test_app_name
    set_env 'APP_NAME', "my-app"
    Vault::Config.app_name.must_equal 'my-app'
  end

  # Vault::Config.app_deploy returns the value of the APP_DEPLOY environment
  # variable.
  def test_app_deploy
    set_env 'APP_DEPLOY', "test"
    Vault::Config.app_deploy.must_equal 'test'
  end

  # Vault::Config.port raises a RuntimeError if no `PORT` environment variable
  # is defined.
  def test_port_raises
    assert_raises RuntimeError do
      Vault::Config.port
    end
  end

  # Vault::Config.port converts the value from the environment to a Fixnum
  def test_port_convert_to_int
    set_env 'PORT', "3000"
    assert_equal(3000, Vault::Config.port)
  end

  # Vault::Config.enable_ssl? is true unless VAULT_TOOLS_DISABLE_SSL is set.
  def test_enable_ssl
    set_env 'VAULT_TOOLS_DISABLE_SSL', nil
    assert Vault::Config.enable_ssl?
    set_env 'VAULT_TOOLS_DISABLE_SSL', 'true'
    refute Vault::Config.enable_ssl?
    set_env 'VAULT_TOOLS_DISABLE_SSL', 'false'
    assert Vault::Config.enable_ssl?
  end

  # Vault::Config.int(VAR) returns nil or VAR as integer.
  def test_int
    assert_equal(nil, Vault::Config.int('FOO'))
    set_env 'FOO', "3000"
    assert_equal(3000, Vault::Config.int('FOO'))
  end

  # Vault::Config.array loads a comma-separated list of words into an array of
  # strings.
  def test_array
    set_env 'ARRAY', ''
    assert_equal([], Vault::Config.array('ARRAY'))
    set_env 'ARRAY', 'apple'
    assert_equal(['apple'], Vault::Config.array('ARRAY'))
    set_env 'ARRAY', 'apple,orange,cherry'
    assert_equal(['apple', 'orange', 'cherry'], Vault::Config.array('ARRAY'))
  end

  # Vault::Config.array raises a RuntimeError if the environment variable
  # doesn't exist.
  def test_array_with_unknown_environment_variable
    assert_raises RuntimeError do
      Vault::Config.array('UNKNOWN')
    end
  end

  # Vault::Config.bool?(var) is only true if the value of var is the string
  # 'true'.  If the var is absent or any other value, it evaluates to false.
  def test_bool_returns_true
    assert_equal(false, Vault::Config.bool?('VAULT_BOOLEAN_VAR'))
    set_env 'VAULT_BOOLEAN_VAR', 'true'
    assert_equal(true, Vault::Config.bool?('VAULT_BOOLEAN_VAR'))
  end

  # Vault::Config.bool?(var) is false if the value of var is anything other
  # than the string 'true'.
  def test_bool_returns_false
    set_env 'VAULT_BOOLEAN_VAR', 'false'
    assert_equal(false, Vault::Config.bool?('VAULT_BOOLEAN_VAR'))
    set_env 'VAULT_BOOLEAN_VAR', 'foo'
    assert_equal(false, Vault::Config.bool?('VAULT_BOOLEAN_VAR'))
    set_env 'VAULT_BOOLEAN_VAR', '1'
    assert_equal(false, Vault::Config.bool?('VAULT_BOOLEAN_VAR'))
  end

  # Vault::Config.sidekiq_concurrency returns the value of the
  # `SIDEKIQ_CONCURRENCY` environment variable or 25 if one isn't defined.
  def test_sidekiq_concurrency
    assert_equal(25, Vault::Config.sidekiq_concurrency)
    set_env 'SIDEKIQ_CONCURRENCY', '10'
    assert_equal(10, Vault::Config.sidekiq_concurrency)
  end
end
