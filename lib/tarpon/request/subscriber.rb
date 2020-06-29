# frozen_string_literal: true

module Tarpon
  module Request
    class Subscriber < Base
      def initialize(app_user_id:)
        @app_user_id = app_user_id
      end

      # rubocop:disable Naming/AccessorMethodName
      def get_or_create
        perform(method: :get, path: path, key: :public)
      end
      # rubocop:enable Naming/AccessorMethodName

      def delete
        perform(method: :delete, path: path, key: :secret)
      end

      def entitlements(entitlement_identifier)
        self.class::Entitlement.new(subscriber_path: path, entitlement_identifier: entitlement_identifier)
      end

      def offerings
        self.class::Offering.new(subscriber_path: path)
      end

      def subscriptions(product_id)
        self.class::Subscription.new(subscriber_path: path, product_id: product_id)
      end

      private

      def path
        "/subscribers/#{@app_user_id}"
      end
    end
  end
end
