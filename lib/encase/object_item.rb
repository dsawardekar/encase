module Encase
  require_relative 'container_item'

  class ObjectItem < ContainerItem
    attr_accessor :injected

    def inject(object, origin = nil)
      if self.injected
        false
      else
        self.injected = super(object, origin)
      end
    end
  end
end
