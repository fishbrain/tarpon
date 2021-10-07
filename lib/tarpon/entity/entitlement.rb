# frozen_string_literal: true

module Tarpon
  module Entity
    class Entitlement
      attr_reader :id, :raw

      def initialize(id, attributes = {})
        @id  = id
        @raw = attributes
      end

      def active?
        expires_date > Time.now.utc
      end

      def expires_date
        Time.iso8601(@raw[:expires_date])
      end

      def purchase_date
        Time.iso8601(@raw[:purchase_date])
      end
    end
  end
end
