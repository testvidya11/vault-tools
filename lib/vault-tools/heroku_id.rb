require 'uuidtools'

module Vault
  module HerokuID
    # Convert a Heroku ID into a v5 UUID.
    #
    # @param heroku_id [String] And app ID, such as `app#1234@heroku.com`, or
    #   a user ID, such as `user#1234@heroku.com`.
    # @return [String] A v5 UUID uniquely representing the ID.
    def self.to_uuid(heroku_id)
      if app_id = heroku_id.slice(/^app#(\d+)\@heroku\.com$/, 1)
        url = "https://vault.heroku.com/apps/#{app_id}"
        UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
      elsif user_id = heroku_id.slice(/^user#(\d+)\@heroku\.com$/, 1)
        url = "https://vault.heroku.com/users/#{user_id}"
        UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
      else
        raise "#{heroku_id} is not a valid Heroku ID."
      end
    end
  end
end
