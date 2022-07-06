# Tarpon

[![Build Status](https://travis-ci.com/fishbrain/tarpon.svg?branch=master)](https://travis-ci.com/fishbrain/tarpon)
[![Gem Version](https://badge.fury.io/rb/tarpon.svg)](https://rubygems.org/gems/tarpon)

A Ruby interface to [RevenueCat's](https://www.revenuecat.com/) REST API.

[Installation](#installation) | [Usage](#usage) | [API Reference](https://www.rubydoc.info/gems/tarpon/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tarpon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tarpon

## Usage

### Configuration

```ruby
Tarpon::Client.configure do |c|
  c.public_api_key = 'your-public-key'
  c.secret_api_key = 'your-secret-key'
  c.timeout        = 5 # a global timeout in seconds for http requests to RevenueCat server, default is 5 seconds
end
```

Get your credentials from the [RevenueCat dashboard](https://app.revenuecat.com/apps/). Read more about [authentication on the RevenueCat docs](https://docs.revenuecat.com/docs/authentication).

#### Configuring multiple clients

If you need to support different configurations (e.g. to target different RevenueCat projects), you can instantiate different Tarpon clients. For example:

```ruby
PROJECT_1_RC_CLIENT = Tarpon::Client.new do |c|
  c.public_api_key = 'project-1-public-key'
  c.secret_api_key = 'project-1-secret-key'
end

PROJECT_2_RC_CLIENT = Tarpon::Client.new do |c|
  c.public_api_key = 'project-2-public-key'
  c.secret_api_key = 'project-2-secret-key'
end
```

And then you can use them instead of calling methods on `Tarpon::Client`. For example:

```ruby
PROEJCT_1_RC_CLIENT
  .subscriber('app_user_id')
  .get_or_create
```

You can also pass configuration values as a Hash to the `Tarpon::Client` constructor, if desired:

```ruby
Tarpon::Client.new(public_api_key: 'public-key', private_api_key: 'private-key')
```

### Performing requests

#### Get or create a subscriber

```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .get_or_create
```

#### Delete a subscriber

```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .delete
```

#### Grant a promotional entitlement

```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .entitlements('entitlement_id')
  .grant_promotional(duration: 'daily', start_time_ms: 1582023714931)
```

Be aware that RevenueCat doesn't create the subscriber automatically. If the `app_user_id` doesn't exist, the request will fail with a `404 Not Found`. Perform a `Tarpon::Client.subscriber('app_user_id').get_or_create` beforehand to make sure the subscriber exists when granting promotional entitlements:

```ruby
Tarpon::Client.subscriber('app_user_id').get_or_create # subscriber is created

Tarpon::Client
  .subscriber('app_user_id')
  .entitlements('entitlement_id')
  .grant_promotional(duration: 'daily', start_time_ms: 1582023714931)
```

Check the [endpoint reference](https://docs.revenuecat.com/reference#grant-a-promotional-entitlement) for valid `duration` values, Tarpon does not perform any input validation.

#### List offerings available to subscriber
```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .offerings
  .list(platform)
```

Where platform is one either ios, android, macos, uikitformac or stripe.

Read more about offerings [here](https://docs.revenuecat.com/docs/entitlements#offerings)
#### Revoke a promotional entitlement

```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .entitlements('entitlement_id')
  .revoke_promotional
```

#### Create a purchase

```ruby
platform = 'ios' # possible values: android|ios|stripe
payload = {
  app_user_id: 'app_user_id',
  fetch_token: 'fetch_token',
}
Tarpon::Client
  .receipt
  .create(platform: platform, payload)
```

Check the [endpoint reference](https://docs.revenuecat.com/reference#receipts) for a valid purchase payload.

#### Defer billing (android)

```ruby
Tarpon::Client
  .subscriber('app_user_id')
  .subscriptions('product_id')
  .defer(expiry_time_ms: 1582023715118)
```

### Handling responses

By default, Tarpon will raise custom errors in the following occasions:

- `Tarpon::NotFoundError` will be raised when RevenueCat server responds with a not found status code.

- `Tarpon::InvalidCredentialsError` will be raised when RevenueCat server responds with unauthorized status code, e.g. invalid API key.

- `Tarpon::ServerError` will be raised when RevenueCat server responds with internal error status code (5xx).

- `Tarpon::TimeoutError` will be raised when RevenueCat server takes too long to respond, based on `Tarpon::Client.timeout`.

- `Tarpon::TooManyRequests` will be raise when RevenueCat server responds with 429 status code.

For success and client error status codes, Tarpon will parse it to the response object.

#### The Response object

```ruby
response = Tarpon::Client
             .subscriber('app_user_id')
             .get_or_create
```

The plain response body from RevenueCat is stored in the `raw` attribute:

```ruby
response.raw
# {
#   request_date_ms: 1582029851163,
#   subscriber: {
#     original_app_user_id: 'app_user_id',
#     ...
#   }
# }
```

Use the `success?` method to know whether the request was successful:

```ruby
response.success? # boolean
```

The subscriber entity is stored in the `subscriber` attribute when the subscriber object is returned by RevenueCat:

```ruby
response.subscriber # <Tarpon::Entity::Subscriber>
```

#### The subscriber entity

The subscriber entity comes with a few goodies that might save you some time.

Get the user entitlements:

```ruby
response.subscriber.entitlements
```

Get only active user entitlements:

```ruby
response.subscriber.entitlements.active
```

#### The entitlement entity

```ruby
response.subscriber.entitlements.each do |entitlement|
  entitlement.expires_date # Ruby time parsed from iso8601
  entitlement.active? # true if expires_date > Time.now.utc
end
```

## Advanced HTTP configuration

You can access the HTTP requests as they are performed for advanced configuration, allowing you to configure things such as logging, instrumentation, more granular timeouts, or using an HTTP proxy.

Under the hood, Tarpon uses the [HTTP.rb](https://github.com/httprb/http) library, which provides an easy to extend API to configure HTTP requests. You can access this by providing a custom `http` Proc when configuring a `Tarpon::Client`.

```ruby
Tarpon::Client.configure do |c|
  c.http = ->(http) do
    http
      .use(instrumentation: { instrumenter: ActiveSupport::Notifications.instrumenter })
      .via('https://custom.proxy.com', 8080)
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fishbrain/tarpon.

Clone the repository using

    $ git clone https://github.com/fishbrain/tarpon.git && cd tarpon

Install development dependencies through Bundler

    $ bundle install

Run tests and linter using

    $ bundle exec rspec && bundle exec rubocop

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
