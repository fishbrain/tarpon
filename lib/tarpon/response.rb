require 'tarpon/entity/subscriber'

module Tarpon
  class Response
    attr_reader :raw, :subscriber

    def initialize(attributes = {})
      @raw        = attributes
      @subscriber = Entity::Subscriber.new(@raw[:subscriber])
    end
  end
end
