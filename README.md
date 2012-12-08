# Vault Tools

Tooling for the Heroku Vault team to enable faster bootstrapping for Ruby projects.

## Installation

Add this line to your application's Gemfile:

    gem 'vault-tools'

## Usage

### Logging

```ruby
  Log.time(name, t)
  #  => "measure=true at=web-40"

  Log.count('foo')
  #  => "measure=true at=foo"
```

### Sinatra Base Class

Includes request logging and health endpoints

```ruby
  class Web < Vault::Web
    helpers Vault::SinatraHelpers::HtmlSerializer
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Releasing

    > bundle exec rake release
