module Tarpon
  class Error < StandardError; end
  class TimeoutError < Error; end
  class NotFoundError < Error; end
end
