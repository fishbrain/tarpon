# frozen_string_literal: true

module Tarpon
  class Error < StandardError; end
  class TimeoutError < Error; end
  class InvalidCredentialsError < Error; end
  class ServerError < Error; end
  class NotFoundError < Error; end
  class TooManyRequests < Error; end
end
