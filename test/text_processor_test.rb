require 'helper'

class TextProcessorTest < Vault::TestCase
  def setup
    set_env 'FERNET_SECRET', 'Mcdej7RFV/yHDrs1P8mrYP9zcw4JxSyReqYyELDrRPY='
  end

  def test_roundtrip
    string = 'foo'
    write = Vault::Tools::TextStorage::NonPrivateWrite.process(string)
    read  = Vault::Tools::TextStorage::NonPrivateRead.process(write)
    assert_equal string, read
  end

  def test_write_is_smaller_size
    string = 'foo' * 100
    write = Vault::Tools::TextStorage::NonPrivateWrite.process(string)
    assert string.size > write.size, "Written String should be smaller than raw string"
  end
end
