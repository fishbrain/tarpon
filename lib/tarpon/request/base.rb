require 'http'

module Tarpon
  module Request
    class Base
      DEFAULT_HEADERS = {
        accept: 'application/json',
        content_type: 'application/json'
      }

      protected

      def perform(method:, path:, key:, headers: {}, body: nil)
        HTTP
          .auth("Bearer #{translate_key(key)}")
          .headers(headers.merge(DEFAULT_HEADERS))
          .timeout(Client.timeout)
          .send(method, "#{Client.base_uri}#{path}", json: body&.compact)
          .then { |response| handle_response(response) }
        rescue HTTP::TimeoutError => e
          raise Tarpon::TimeoutError, e
      end

      def translate_key(key)
        Client.send("#{key}_api_key")
      end

      private

      def handle_response(response)
        case response.code
        when 401
          raise Tarpon::InvalidCredentialsError, 'Invalid credentials, fix your API keys'
        when 500..505
          raise Tarpon::ServerError, 'RevenueCat failed to fulfill the request'
        else
          Tarpon::Response.new(
            response.status,
            parse_body(response.body)
          )
        end
      end

      def parse_body(body)
        JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
