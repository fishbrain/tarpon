# frozen_string_literal: true

require 'tarpon/configuration'

module Tarpon
  class Client
    extend Configuration

    class << self
      def subscriber(app_user_id)
        Request::Subscriber.new(app_user_id: app_user_id)
      end

      def receipt
        Request::Receipt.new
      end
    end
  end
end
