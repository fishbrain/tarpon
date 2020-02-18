module Tarpon
  class Error < StandardError; end
  class TimeoutError < Error; end
  class InvalidCredentialsError < Error; end
  class ServerError < Error; end
end
