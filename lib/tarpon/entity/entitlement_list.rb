# frozen_string_literal: true

module Tarpon
  module Entity
    class EntitlementList
      include Enumerable

      def initialize(entitlements = {})
        @entitlements = entitlements.map { |id, params| Entitlement.new(id, params) }
      end

      def [](index)
        @entitlements[index]
      end

      def active
        @entitlements.select(&:active?)
      end

      def each
        @entitlements.each { |e| yield e }
      end
    end
  end
end
