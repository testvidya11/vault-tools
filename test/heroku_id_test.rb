require 'uuidtools'

class HerokuIDTest < Vault::TestCase
  # HerokuID.to_uuid converts app IDs to a v5 UUID based on a URL scheme.
  def test_to_uuid_with_app_id
    url = "https://vault.heroku.com/apps/1234"
    uuid = UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
    assert_equal(uuid, Vault::HerokuID.to_uuid('app#1234@heroku.com'))
  end

  # HerokuID.to_uuid converts user IDs to a v5 UUID based on a URL scheme.
  def test_to_uuid_with_user_id
    url = "https://vault.heroku.com/users/1234"
    uuid = UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
    assert_equal(uuid, Vault::HerokuID.to_uuid('user#1234@heroku.com'))
  end

  # HerokuID.to_uuid raises a RuntimeError if the specified ID doesn't match
  # the expected format.
  def test_uuid_with_invalid_heroku_id
    error = assert_raises(RuntimeError) do
      Vault::HerokuID.to_uuid('invalid#1234@heroku.com')
    end
    assert_equal('invalid#1234@heroku.com is not a valid Heroku ID.',
                 error.message)
  end
end
