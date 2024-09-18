# frozen_string_literal: true

module Tarpon
  module Entity
    class Subscriber
      attr_reader :raw, :entitlements

      def initialize(attributes = {})
        @raw          = attributes
        @entitlements = EntitlementList.new(attributes[:entitlements] || {})
      end
    end
  end
end
