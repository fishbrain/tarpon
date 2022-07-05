# frozen_string_literal: true

require 'forwardable'
require 'tarpon/configuration'

module Tarpon
  class Client
    include Configuration

    def self.default
      @default ||= new
    end

    def initialize(**config, &block)
      config.each { |key, val| send("#{key}=", val) }
      yield self if block
    end

    class << self
      extend Forwardable
      def_delegators :default, *Configuration.public_instance_methods(true)
      def_delegators :default, :subscriber, :receipt
    end

    def subscriber(app_user_id)
      Request::Subscriber.new(app_user_id: app_user_id, client: self)
    end

    def receipt
      Request::Receipt.new(client: self)
    end
  end
end
