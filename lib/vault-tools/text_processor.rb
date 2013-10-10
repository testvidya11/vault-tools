module Vault::Tools
  module Storage
    class NonPrivateWrite < Vault::Pipeline
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
    end
  end
end
