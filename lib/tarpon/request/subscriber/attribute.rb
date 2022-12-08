# frozen_string_literal: true

module Tarpon
  module Request
    class Subscriber
      class Attribute < Base
        def initialize(subscriber_path:, **opts)
          super(**opts)
          @subscriber_path = subscriber_path
        end

        def update(**data)
          body = {
            attributes: data
          }
          perform(method: :post, path: path, key: :public, body: body)
        end

        private

        def path
          "#{@subscriber_path}/attributes"
        end
      end
    end
  end
end
