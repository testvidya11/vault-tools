require 'fernet'

module Vault::Tools
  module Storage
    class NonPrivateWrite < Vault::Pipeline
      FERNET_TOKENIZE = lambda { |string|
        secret = ENV['FERNET_SECRET'] || 'Mcdej7RFV/yHDrs1P8mrYP9zcw4JxSyReqYyELDrRPY='
        Fernet.generate(secret) do |generator|
          generator.data = { data: string }
        end
      }

      use FERNET_TOKENIZE

      DEFLATE = lambda { |string|
        z = Zlib::Deflate.new
        dst = z.deflate(string, Zlib::FINISH)
        z.close
        dst
      }
      use DEFLATE
    end

    class NonPrivateRead < Vault::Pipeline
      INFLATE = lambda { |string|
        z = Zlib::Inflate.new
        dst = z.inflate(string)
        z.close
        dst
      }

      use INFLATE

      FERNET_DECODE = lambda { |token|
        secret = ENV['FERNET_SECRET'] || 'Mcdej7RFV/yHDrs1P8mrYP9zcw4JxSyReqYyELDrRPY='
        verified = Fernet.verify(secret, token) do |verifier|
          verifier.data['data']
        end
      }

      use FERNET_DECODE
    end
  end
end
