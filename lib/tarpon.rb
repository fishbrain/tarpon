require 'tarpon/version'
require 'tarpon/configuration'
require 'tarpon/client'
require 'tarpon/entity/entitlement'
require 'tarpon/entity/entitlement_list'
require 'tarpon/entity/subscriber'
require 'tarpon/request/base'
require 'tarpon/request/subscriber'
require 'tarpon/request/receipt'
require 'tarpon/response'

module Tarpon
  class Error < StandardError; end
end
