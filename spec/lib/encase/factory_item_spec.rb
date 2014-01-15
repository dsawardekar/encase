require 'spec_helper'
require 'encase/factory_item'

module Encase
  class MyClass
  end

  describe FactoryItem do
    let(:container) {
      c = double()
      c.stub(:inject).with(anything()) { true }
      c
    }

    let(:factory_item) {
      FactoryItem.new(container, :lorem, MyClass)
    }

    it 'creates a new instance on every fetch' do
      factory_item.reify()

      instance1 = factory_item.fetch()
      instance2 = factory_item.fetch()

      expect(instance1).to_not eq(instance2)
    end

    it 'applies injection on created instance' do
      container.stub(:inject) do |to_inject|
        expect(to_inject).to be_a(MyClass)
        true
      end

      factory_item.instance
    end
  end
end
