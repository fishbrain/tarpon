# frozen_string_literal: true

require 'tarpon/entity/offerings'

module Tarpon
  module Request
    class Subscriber
      class Offering < Base
        def initialize(subscriber_path:)
          @subscriber_path = subscriber_path
        end

        def list(platform)
          response = perform(method: :get, path: path.to_s, headers: { 'x-platform': platform }, key: :public)
          return response unless response.success?

          Tarpon::Entity::Offerings.from_json(response.raw)
        end

        private

        def path
          "#{@subscriber_path}/offerings"
        end
      end
    end
  end
end
