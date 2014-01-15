require 'spec_helper'
require 'encase/object_item'

module Encase
  describe ObjectItem do
    let(:container) {
      c = double()
      c.stub(:inject).with(anything()) { true }
      c
    }

    it 'applies injection if not injected' do
      object_item = ObjectItem.new(container, :lorem, 'lorem')

      expect(object_item.inject('lorem')).to be_true
      expect(object_item.injected).to be_true
    end

    it 'does not apply injection if already injected' do
      object_item = ObjectItem.new(container, :lorem, 'lorem')
      object_item.inject('lorem')

      expect(object_item.inject('lorem')).to be_false
      expect(object_item.injected).to be_true
    end
  end
end
