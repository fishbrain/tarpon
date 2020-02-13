require 'http'

module Tarpon
  module Request
    def self.perform(method:, path:, key:)
      HTTP
        .auth("Bearer #{translate_key(key)}")
        .headers(accept: 'application/json', content_type: 'application/json')
        .send(method, "#{Client.base_uri}#{path}")
    end

    def self.translate_key(key)
      Client.send("#{key}_api_key")
    end
  end
end
