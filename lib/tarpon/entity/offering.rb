# frozen_string_literal: true

module Tarpon
  module Entity
    Package = Struct.new(:identifier, :platform_identifier)
    class Offering
      attr_reader :identifier, :description, :packages

      def initialize(identifier:, description:, packages:, **)
        @identifier = identifier
        @description = description
        @packages = packages.map do |package|
          Package.new(package[:identifier], package[:platform_product_identifier])
        end
      end
    end
  end
end
