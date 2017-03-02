# Fieldwork

A Ruby client for Fieldwork.

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
