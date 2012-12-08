class TestSpec < MiniTest::Unit::TestCase

  def test_default_spec_class_is_vault_spec
    assert_equal Vault::Spec, MiniTest::Spec.spec_type('')
  end

end
