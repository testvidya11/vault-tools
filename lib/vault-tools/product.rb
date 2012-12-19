require 'uuidtools'

module Vault
  module Product
    # Convert a product name into a v5 UUID.
    #
    # @param name [String] A product name.
    # @raise [RuntimeError] Raised if an empty product name is provided.
    # @return [String] A v5 UUID that uniquely represents the product.
    def self.name_to_uuid(name)
      raise "Product name can't be empty." if name.empty?
      url = "https://vault.heroku.com/products/#{name}"
      UUIDTools::UUID.sha1_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
    end
  end
end
