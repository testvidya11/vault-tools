require 'minitest/unit'
require 'minitest/spec'
require 'rack/test'

# Base class for Vault test cases.
class Vault::TestCase < MiniTest::Unit::TestCase
  def setup
    super
    Scrolls.stream = StringIO.new
  end

  def teardown
    super
  end
end

class Vault::Spec < MiniTest::Spec
  before do
    Scrolls.stream = StringIO.new
  end
end

# Register our Spec class as the default
MiniTest::Spec.register_spec_type //, Vault::Spec

module Vault::TestHelpers
  def self.include_in_all(_module)
    Vault::TestCase.send(:include, _module)
    Vault::Spec.send(:include, _module)
  end

  def save_and_open_page(html = nil, name = 'page.html', i = 1)
    html ||= last_response.body
    name = "page_#{i=i+1}.html" while File.exist? name
    File.open(name, 'w') { |f| f << html }
    system "open #{name}"
  end

  def set_doc(body)
    @doc = Nokogiri::HTML(body)
  end

  def doc
    @doc || Nokogiri::HTML(last_response.body)
  end

  def css(string)
    doc.css(string)
  end

  def assert_includes_css(css_string)
    exists = doc.css(css_string).first
    assert exists, "Last response must include #{css_string}"
  end

  def assert_css(css_string, content)
    e = css(css_string).first
    assert e, "Element not found: #{css_string}"
    assert_includes e.content, content
  end

  def with_env(key, value)
    old_env = ENV[key]
    ENV[key] = value
    yield
  ensure
    ENV[key] = old_env
  end
end

Vault::TestHelpers.include_in_all Rack::Test::Methods
Vault::TestHelpers.include_in_all Vault::TestHelpers
