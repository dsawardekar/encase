require 'spec_helper'
require 'encase/singleton_item'

module Encase
  class MySingletonClass
  end

  describe SingletonItem do
    let(:container) {
      c = double()
      c.stub(:inject).with(anything()) { true }
      c
    }

    let(:singleton_item) {
      s = SingletonItem.new(container)
      s.store(:lorem, MySingletonClass)
      s
    }

    it 'returns the same object on every fetch' do
      singleton_item.reify()

      instance1 = singleton_item.fetch()
      instance2 = singleton_item.fetch()

      expect(instance1).to eq(instance2)
    end
  end
end
