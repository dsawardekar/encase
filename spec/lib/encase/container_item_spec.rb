require 'spec_helper'
require 'encase/container_item'

module Encase
  shared_examples 'a container_item' do
    it 'stores container' do
      expect(container_item.container).to eq(container)
    end

    it 'stores item key - value pair' do
      expect(container_item.key).to eq(container_item_key)
      expect(container_item.value).to eq(container_item_value)
    end

    it 'reifies value' do
      container_item.reify()
      expect(container_item.reified_value).to eq(container_item_value_reified)
    end

    it 'does not reify if already reified' do
      container_item.reify()
      expect(container_item.reified?).to be_true

      expect(container_item.reify()).to be_false
      expect(container_item.reified?).to be_true
    end

    it 'applies injection' do
      container_item.reify()
      expect(container_item.inject()).to be_true
    end

    it 'returns instance for item' do
      expect(container_item.instance).to eq(container_item_value_reified)
    end
  end

  describe ContainerItem do
    let(:container) do
      c = double()
      c.stub(:inject).with(anything()) { true }
      c
    end

    let(:container_item_key) { :lorem }
    let(:container_item_value) { 'lorem' }
    let(:container_item_value_reified) { 'lorem' }
    let(:container_item) {
      ContainerItem.new(container, container_item_key, container_item_value)
    }

    context 'without proc' do
      it_behaves_like "a container_item"
    end

    context 'with proc' do
      context 'without argument' do
        let(:container_item_value) {
          Proc.new do
            'lorem'
          end
        }

        it_behaves_like 'a container_item'
      end

      context 'with argument' do
        let(:container_item_value) {
          Proc.new do |c|
            expect(c).to eq(container)
            'lorem'
          end
        }

        it_behaves_like 'a container_item'
      end
    end
  end
end
