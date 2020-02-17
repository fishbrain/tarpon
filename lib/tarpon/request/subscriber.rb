module Tarpon
  module Request
    class Subscriber < Base
      def initialize(app_user_id:)
        @app_user_id = app_user_id
      end

      def get_or_create
        perform(method: :get, path: path, key: :public)
      end

      def delete
        perform(method: :delete, path: path, key: :secret)
      end

      def entitlements(entitlement_identifier)
        self.class::Entitlement.new(subscriber_path: path, entitlement_identifier: entitlement_identifier)
      end

      def subscriptions(product_id)
        self.class::Subscription.new(subscriber_path: path, product_id: product_id)
      end

      private

      def path
        "/subscribers/#{@app_user_id}"
      end

      class Entitlement < Base
        def initialize(subscriber_path:, entitlement_identifier:)
          @subscriber_path = subscriber_path
          @entitlement_identifier = entitlement_identifier
        end

        def grant_promotional(duration:, start_time_ms: nil)
          body = {
            duration: duration,
            start_time_ms: start_time_ms,
          }

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

      class Subscription < Base
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
end
