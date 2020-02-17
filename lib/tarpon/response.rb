module Tarpon
  class Response
    attr_reader :raw, :subscriber

    def initialize(attributes)
      @raw        = attributes
      @subscriber = @raw[:subscriber].nil? ? nil : Entity::Subscriber.new(@raw[:subscriber])
    end
  end
end
