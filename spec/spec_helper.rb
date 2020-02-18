require 'bundler/setup'
require 'tarpon'
require 'factory_bot'
require 'webmock/rspec'
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  WebMock.disable_net_connect!(allow_localhost: true)

  config.before(:suite) do
    Tarpon::Client.configure do |c|
      c.public_api_key = 'public-key'
      c.secret_api_key = 'secret-key'
      c.timeout        = 1
    end
  end
end
