module Tarpon
  class Response
    attr_reader :raw, :subscriber

    def initialize(status, attributes)
      @status     = status
      @raw        = attributes
      @subscriber = @raw[:subscriber].nil? ? nil : Entity::Subscriber.new(@raw[:subscriber])
    end

    def success?
      @status.success?
    end
  end
end
