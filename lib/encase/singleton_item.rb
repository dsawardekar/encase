module Encase
  require_relative 'factory_item'

  class SingletonItem < FactoryItem
    attr_accessor :singleton

    def fetch
      self.singleton = super unless self.singleton
      self.singleton
    end
  end
end
