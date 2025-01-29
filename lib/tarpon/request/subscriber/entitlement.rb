# frozen_string_literal: true

module Tarpon
  module Request
    class Subscriber
      class Entitlement < Base
        def initialize(subscriber_path:, entitlement_identifier:, **opts)
          super(**opts)
          @subscriber_path = subscriber_path
          @entitlement_identifier = entitlement_identifier
        end

        def grant_promotional(duration: nil, start_time_ms: nil, end_time_ms: nil)
          body = {
            duration: duration,
            start_time_ms: start_time_ms,
            end_time_ms: end_time_ms
          }.compact

          perform(method: :post, path: "#{path}/promotional", key: :secret, body: body)
        end

        def revoke_promotional
          perform(method: :post, path: "#{path}/revoke_promotionals", key: :secret)
        end

        private

        def path
          "#{@subscriber_path}/entitlements/#{@entitlement_identifier}"
        end
      end
    end
  end
end
