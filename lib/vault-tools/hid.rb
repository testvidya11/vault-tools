require 'uuidtools'

module Vault
  module HID
    USER_HID_REGEX = /\Auser(\d+)@heroku.com/
    APP_HID_REGEX  = /\Aapp(\d+)@heroku.com/

    # Convert a Heroku app ID or user ID into a v5 UUID.
    #
    # @param heroku_id [String] A Heroku app ID or user ID.
    # @raise [ArgumentError] Raised if a malformed Heroku ID is provided.
    # @return [String] A v5 UUID that uniquely represents the app.
    def self.hid_to_uuid(heroku_id)
      case heroku_id
      when /^user/
        User.hid_to_uuid(heroku_id)
      when /^app/
        App.hid_to_uuid(heroku_id)
      else
        raise ArgumentError, "#{heroku_id} is not a valid Heroku app or " +
                             "user ID."
      end
    end

    def self.hid?(string)
      case string
      when APP_HID_REGEX; :app;
      when USER_HID_REGEX; :user;
      end
    end
  end
end
