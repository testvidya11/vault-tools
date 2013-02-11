require 'opentoken'
require 'yajl/json_gem'

module Vault
  # A user agent connects to a service to use its API.
  #
  # This user agent can generate an OpenToken token with details about the
  # user.  This is intended to be passed back to the server using, for
  # example, HTTP Basic Auth.  The server can convert the token back into a
  # user agent instance.
  class UserAgent
    class << self
      # The secret to use when encoding and decoding OpenToken tokens.
      attr_accessor :opentoken_secret
    end
    # The user agent's username.
    attr_reader :username
    # Additional details about the user agent.
    attr_reader :detail

    # Unpack an OpenToken token and recreate a UserAgent using the values
    # inside it.
    #
    # @param token [String] An OpenToken hash created from UserAgent#encode.
    # @return [UserAgent] The instance created using the values unpacked from
    #   the token.
    def self.decode(token)
      password = OpenToken.password
      begin
        OpenToken.password = opentoken_secret
        attributes = OpenToken.decode(token)
        UserAgent.new(attributes['username'], JSON.parse(attributes['detail']))
      ensure
        OpenToken.password = password
      end
    end

    # Instantiate a user agent.
    #
    # @param username [String] The username of the user agent.
    # @param detail [Hash] Optionally, a set of key/value to store with the
    #   user agent.  Keys must be strings and values must be JSON
    #   serializable.  Default is an empty hash.
    def initialize(username, detail={})
      @username = username
      @detail = detail
    end

    # Pack UserAgent values into an OpenToken token.
    #
    # @return [String] An OpenToken hash that uniquely represents this user
    #   agent.
    def encode
      password = OpenToken.password
      begin
        OpenToken.password = UserAgent.opentoken_secret
        attributes = {'username' => @username, 'detail' => @detail.to_json}
        OpenToken.encode(attributes, OpenToken::Cipher::AES_128_CBC)
      ensure
        OpenToken.password = password
      end
    end
  end
end
