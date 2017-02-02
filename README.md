# Fieldwork

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fieldwork`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fieldwork'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fieldwork

## Usage

```ruby
# Configure the client with your project id and public key
Fieldwork.configure do |config|
  config.project_id = "your_project_id"
  config.project_public_key = "your_project_public_key"
end

# Track events anywhere in your application
Fieldwork.track_event("customer_created", {
  id: 675,
  name: "Alice Pyman"
  email: "apyman@example.com"
  newsletter_sign_up: true,
  address: {
    address_line_1: "17 Red St"
    suburb: "Northcote",
    city: "Melbourne",
    state: "VIC",
    postcode: "3070"
  }
})

# Add or update entities anywhere in your application
Fieldwork.add_entity("product", {
  id: 232,
  name: "The Great Gatsby",
  author: "F Scott Fitzgerald",
  retail_price_cents: 2995,
  categories: ["fiction","classics"]
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

