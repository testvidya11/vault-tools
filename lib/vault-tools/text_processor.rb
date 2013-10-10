require 'fernet'

module Vault::Tools
  module TextStorage
    FERNET_ENCODE = lambda { |string|
      secret = ENV['FERNET_SECRET']
      Fernet.generate(secret, string)
    }

    FERNET_DECODE = lambda { |token|
      secret = ENV['FERNET_SECRET']
      verifier = Fernet.verifier(secret, token)
      verifier.message
    }

    DEFLATE = lambda { |string|
      z = Zlib::Deflate.new
      dst = z.deflate(string, Zlib::FINISH)
      z.close
      dst
    }

    INFLATE = lambda { |string|
      z = Zlib::Inflate.new
      dst = z.inflate(string)
      z.close
      dst
    }

    class NonPrivateWrite < Vault::Pipeline
      use DEFLATE
      use FERNET_ENCODE
    end

    class NonPrivateRead < Vault::Pipeline
      use FERNET_DECODE
      use INFLATE
    end
  end
end
