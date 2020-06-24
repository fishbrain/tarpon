# frozen_string_literal: true

module Tarpon
  module Entity
    Package = Struct.new(:identifier, :platform_identifier)
    class Offering
      attr_reader :identifier, :description, :packages

      def self.from_json(json)
        id = json[:identifier]
        description = json[:description]
        packages = json[:packages].map do |package|
          Package.new(identifier: package[:identifier], platform_identifier: package[:platform_product_identifier])
        end
        new(id, description, packages)
      end

      def initialize(identifier, description, packages)
        @identifier = identifier
        @description = description
        @packages = packages
      end
    end
  end
end
