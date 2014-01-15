module Encase
  require_relative 'container_item'

  class FactoryItem < ContainerItem
    def fetch
      reified_value.new
    end
  end
end
