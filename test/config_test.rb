require 'helper'

class ConfigTest < Vault::TestCase

  # Returns DATABASE_URL with no params
  def test_database_url
    set_env 'DATABASE_URL', "postgres:///foo"
    Vault::Config.database_url.must_equal 'postgres:///foo'
  end

  # Returns #{kind}_DATABASE_URL with one param
  def test_database_url_takes_and_capitalizes_params
    set_env 'FOO_DATABASE_URL', "postgres:///foo"
    Vault::Config.database_url('foo').must_equal 'postgres:///foo'
  end

  def test_database_url_raises_when_not_found
    assert_raises RuntimeError do
      Vault::Config.database_url('foo')
    end
  end

  def test_app_name
    Vault::Config.app_name.must_equal nil
    set_env 'APP_NAME', "my-app"
    Vault::Config.app_name.must_equal 'my-app'
  end

  def test_port_raises
    assert_raises RuntimeError do
      Vault::Config.port
    end
  end

  def test_port_convert_to_int
    set_env 'PORT', "3000"
    Vault::Config.port.must_equal 3000
  end
end
