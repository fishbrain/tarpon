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
          .send(method, "#{Client.base_uri}#{path}", json: body&.compact)
          .to_s
      end

      def translate_key(key)
        Client.send("#{key}_api_key")
      end
    end
  end
end
