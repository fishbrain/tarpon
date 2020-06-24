# frozen_string_literal: true

require 'tarpon/entity/offering'

module Tarpon
  module Entity
    class Offerings
      attr_reader :current_offering_id, :offerings

      def self.from_json(json)
        current_offering = json[:current_offering_id]
        offerings = json[:offerings].each_with_object({}) do |offering, map|
          map[offering[:identifier]] = Tarpon::Entity::Offering.from_json(offering)
        end
        new(current_offering, offerings)
      end

      def initialize(current, offerings)
        @current_offering_id = current
        @offerings = offerings
      end

      def get_by_identifier(identifier)
        @offerings[identifier]
      end
    end
  end
end
