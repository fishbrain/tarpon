# Tarpon

A ruby interface to RevenueCat REST API.

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
  c.timeout        = 1 # a global timeout in seconds for http requests to RevenueCat server, default is 5 seconds
end
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

Check the [endpoint reference](https://docs.revenuecat.com/reference#grant-a-promotional-entitlement) for valid `duration` values, Tarpon does not perform any input validation.

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

Tarpon will raise custom errors in a few occasions:

- `Tarpon::InvalidCredentialsError` will be raised when RevenueCat server responds with unauthorized status code, e.g. invalid API key.

- `Tarpon::ServerError` will be raised when RevenueCat server responds with internal error status code (5xx).

- `Tarpon::TimeoutError` will be raised when RevenueCat server takes too long to respond, based on `Tarpon::Client.timeout`.


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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fishbrain/tarpon.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
