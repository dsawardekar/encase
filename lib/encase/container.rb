require 'encase/container_item_factory'

module Encase
  class Container
    attr_accessor :parent

    def initialize(parent = nil)
      @parent = parent
      @items = {}
    end

    def contains?(key)
      @items.key?(key)
    end

    def inject(object)
      klass = object.class
      if klass.respond_to?(:needs_to_inject)
        needs_to_inject = find_needs_to_inject(klass)
        needs_to_inject.each do |need|
          object.instance_variable_set(
            "@#{need}", lookup(need)
          )
        end

        object.container = self if object.respond_to?(:container)
        object.on_inject() if object.respond_to?(:on_inject)

        true
      else
        false
      end
    end

    def find_needs_to_inject(klass)
      needs = []
      klass.ancestors.each do |ancestor|
        if ancestor.respond_to?(:needs_to_inject) && !ancestor.needs_to_inject.nil?
          needs.concat(ancestor.needs_to_inject)
        end
      end

      needs
    end

    def register(type, key, value, block)
      item = ContainerItemFactory.build(type, self)
      item.store(key, value || block)
      @items[key] = item
      self
    end

    def unregister(key)
      @items.delete(key)
      self
    end

    def clear
      @items.clear
      self
    end

    def object(key, value = nil, &block)
      register('object', key, value, block)
      self
    end

    def factory(key, value = nil, &block)
      register('factory', key, value, block)
      self
    end

    def singleton(key, value = nil, &block)
      register('singleton', key, value, block)
      self
    end

    def lookup(key, origin = nil)
      if contains?(key)
        item = @items[key]
        item.instance(origin)
      elsif !parent.nil?
        origin = self if origin.nil?
        parent.lookup(key, origin)
      else
        raise KeyError.new("Key:#{key} not found in container.")
      end
    end

    def configure(&block)
      instance_exec(&block)
      self
    end

    def child
      Container.new(self)
    end
  end
end
