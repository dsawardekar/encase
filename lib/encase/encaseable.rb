module Encase
  module Encaseable
    def needs(*deps)
      if @needs_to_inject
        @needs_to_inject.concat(deps)
      else
        @needs_to_inject = deps
        attr_accessor :container
      end

      attr_accessor *deps
    end

    def needs_to_inject
      @needs_to_inject
    end

    def needs_to_inject=(value)
      @needs_to_inject = value
    end
  end
end
