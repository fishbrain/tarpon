# frozen_string_literal: true

require 'tarpon/entity/offerings'

module Tarpon
  module Request
    class Subscriber
      class Offering < Base
        def initialize(subscriber_path:, **opts)
          super(**opts)
          @subscriber_path = subscriber_path
        end

        def create_override(offering_id)
          perform(method: :post, path: "#{path}/#{offering_id}/override", key: :secret)
        end

        def remove_override
          perform(method: :delete, path: "#{path}/override", key: :secret)
        end

        def list(platform)
          response = perform(method: :get, path: path.to_s, headers: { 'x-platform': platform.to_s }, key: :public)
          return response unless response.success?

          Tarpon::Entity::Offerings.new(**response.raw)
        end

        private

        def path
          "#{@subscriber_path}/offerings"
        end
      end
    end
  end
end
