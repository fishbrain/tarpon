# frozen_string_literal: true

module Tarpon
  module Configuration
    attr_accessor :public_api_key, :secret_api_key
    attr_writer :base_uri, :timeout, :http_middleware

    def configure
      yield self
    end

    def base_uri
      @base_uri || 'https://api.revenuecat.com/v1'
    end

    def timeout
      @timeout || 5
    end

    def http_middleware
      @http_middleware ||= ->(http_client) { http_client }
    end
  end
end
