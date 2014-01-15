require 'encase/version'
require 'encase/encaseable'

module Encase
  def self.included(base)
    base.extend Encaseable
  end
end
