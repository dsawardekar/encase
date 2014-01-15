module Encase
  class ContainerItem
    attr_accessor :container
    attr_accessor :key
    attr_accessor :value
    attr_accessor :reified_value

    def initialize(container, key, value)
      self.container = container
      self.key = key
      self.value = value
    end

    def inject
      self.container.inject(self.reified_value)
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
    def instance
      reify unless reified?
      fetch
    end
  end
end
