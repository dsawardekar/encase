module Encase
  require_relative 'container_item'

  class ObjectItem < ContainerItem
    attr_accessor :injected

    def inject(object)
      if self.injected
        false
      else
        self.injected = super(object)
      end
    end
  end
end
