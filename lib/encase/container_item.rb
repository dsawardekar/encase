module Encase
  class ContainerItem
    attr_accessor :container
    attr_accessor :key
    attr_accessor :value
    attr_accessor :reified_value

    def initialize(container)
      self.container = container
    end

    def store(key, value)
      self.key = key
      self.value = value
    end

    def inject(object, origin = nil)
      if origin.nil?
        container = self.container
      else
        container = origin
      end

      container.inject(object)
    end

    def reify
      return false if reified?

      if value.is_a? Proc
        if value.arity == 1
          self.reified_value = value.call(container)
        else
          self.reified_value = value.call
        end
      else
        self.reified_value = value
      end

      true
    end

    def reified?
      !self.reified_value.nil?
    end

    # returns just the reified value by default
    def fetch
      reified_value
    end

    # public api
    def instance(origin = nil)
      reify unless reified?
      object = fetch
      inject(object, origin)

      object
    end
  end
end
