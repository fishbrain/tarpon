# frozen_string_literal: true

require 'http'

module Tarpon
  module Request
    class Base
      DEFAULT_HEADERS = {
        accept: 'application/json',
        content_type: 'application/json'
      }.freeze

      protected

      def perform(method:, path:, key:, headers: {}, body: nil)
        HTTP
          .timeout(Client.timeout)
          .auth("Bearer #{api_key(key)}")
          .headers(headers.merge(DEFAULT_HEADERS))
          .send(method, "#{Client.base_uri}#{path}", json: body&.compact)
          .yield_self { |http_response| handle_response(http_response) }
      rescue HTTP::TimeoutError => e
        raise Tarpon::TimeoutError, e
      end

      private

      def api_key(type)
        Client.send("#{type}_api_key")
      end

      def parse_body(http_response)
        return {} if http_response.body.empty?

        JSON.parse(http_response.body, symbolize_names: true)
      end

      def create_response(http_response)
        Tarpon::Response.new(http_response.status, parse_body(http_response))
      end
      def handle_response(http_response, raise_on_error: false)
        case http_response.code
        when 200..299
          create_response(http_response)
        else
          handle_error(http_response, raise_on_error: raise_on_error)
        end
      end

      def handle_error(http_response, raise_on_error:)
        case http_response.code
        when 401
          raise Tarpon::InvalidCredentialsError, 'Invalid credentials, fix your API keys'
        when 500..599
          raise Tarpon::ServerError, 'RevenueCat failed to fulfill the request'
        when 404
          raise Tarpon::NotFoundError
        else
          create_response(http_response)
        end
      end
    end
  end
end
