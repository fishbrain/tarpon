# frozen_string_literal: true

module Tarpon
  module Request
    class Subscriber::Subscription < Base
      def initialize(subscriber_path:, product_id:)
        @subscriber_path = subscriber_path
        @product_id = product_id
      end

      def defer(expiry_time_ms:)
        body = { expiry_time_ms: expiry_time_ms }

        perform(method: :post, path: "#{path}/defer", key: :secret, body: body)
      end

      private

      def path
        "#{@subscriber_path}/subscriptions/#{@product_id}"
      end
    end
  end
end
