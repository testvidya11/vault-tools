require 'helper'


class TextProcessorTest < Vault::TestCase
  def test_roundtrip
    string = 'foo'
    write = Vault::Tools::Storage::NonPrivateWrite.process(string)
    read  = Vault::Tools::Storage::NonPrivateRead.process(write)
    assert_equal string, read
  end
end
