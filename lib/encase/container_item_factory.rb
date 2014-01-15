module Encase
  require_relative 'object_item'
  require_relative 'factory_item'
  require_relative 'singleton_item'

  class ContainerItemFactory
    def self.build(type, container)
      container_item_for(type).new(container)
    end

    def self.container_item_for(type)
      case type
      when 'object' then ObjectItem
      when 'factory' then FactoryItem
      when 'singleton' then SingletonItem
      else
        ContainerItem
      end
    end
  end
end
