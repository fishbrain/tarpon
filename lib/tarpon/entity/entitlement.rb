module Tarpon
  module Entity
    class Entitlement
      attr_reader :id, :raw

      def initialize(id, attributes = {})
        @id  = id
        @raw = attributes
      end

      def active?
        expires_date >= Time.now.utc
      end

      def expires_date
        return nil if @raw['expires_date'].nil? || @raw['expires_date'].empty?

        Time.iso8601(@raw['expires_date'])
      end
    end
  end
end
