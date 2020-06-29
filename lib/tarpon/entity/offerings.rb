# frozen_string_literal: true

require 'tarpon/entity/offering'

module Tarpon
  module Entity
    class Offerings
      include Enumerable

      attr_reader :current_offering_id, :offerings

      def initialize(current_offering_id:, offerings:, **)
        @current_offering_id = current_offering_id
        @offerings = offerings.each_with_object({}) do |offering, map|
          map[offering[:identifier].to_sym] = Tarpon::Entity::Offering.new(offering)
        end
      end

      def each
        @offerings.each { |o| yield o }
      end

      def [](identifier)
        @offerings[identifier.to_sym]
      end
    end
  end
end
