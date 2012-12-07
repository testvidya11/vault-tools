# Vault Tools

Tooling for the Heroku Vault team to enable faster bootstrapping for Ruby projects.

## Installation

Add this line to your application's Gemfile:

    gem 'vault-tools'

## Usage

### Sinatra Base Class

Includes request logging and health endpoints

```ruby
  class Web < Vault::Web
    helpers Vault::SinatraHelpers::HtmlSerializer
  end
```

### Test Base Classes

Provides a Stock TestCase and Spec classes to customize.

To extend your test classes uniformly, use the Vault::

```ruby
module MyTestHelperClass
  def app; Vault::InvoiceBuilder::Web; end
end

Vault::TestHelpers.include_in_all Vault::InvoiceBuilderHelpers
```

Now you have an `#app` method in your `Vault::TestCase` and your `Vault::Spec`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Releasing

    > bundle exec rake release
