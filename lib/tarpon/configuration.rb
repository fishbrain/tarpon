module Tarpon
  module Configuration
    attr_accessor :public_api_key, :secret_api_key
    attr_writer :base_uri

    def configure
      yield self
    end

    def base_uri
      @base_uri || 'https://api.revenuecat.com/v1'
    end
  end
end
