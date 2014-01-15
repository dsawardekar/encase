module Encase
  require_relative 'container_item'

  class ObjectItem < ContainerItem
    attr_accessor :injected

    def inject
      if self.injected
        false
      else
        self.injected = super
      end
    end
  end
end
