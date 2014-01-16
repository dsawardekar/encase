require 'spec_helper'
require 'encase/container_item_factory'
require 'encase/container_item'
require 'encase/object_item'
require 'encase/factory_item'
require 'encase/singleton_item'

module Encase
  shared_examples "a container_item_factory" do
    it 'finds container_item\'s constructor' do
      expect(
        ContainerItemFactory.container_item_for(type)
      ).to eq(type_constructor)
    end

    it 'builds container_item' do
      expect(
        ContainerItemFactory.build(type, container)
      ).to be_a(type_constructor)
    end
  end

  describe ContainerItemFactory do
    let(:container) { double() }

    context 'with object type' do
      let(:type) { 'object' }
      let(:type_constructor) { ObjectItem }

      it_behaves_like 'a container_item_factory'
    end

    context 'with factory type' do
      let(:type) { 'factory' }
      let(:type_constructor) { FactoryItem }

      it_behaves_like 'a container_item_factory'
    end

    context 'with singleton type' do
      let(:type) { 'singleton' }
      let(:type_constructor) { SingletonItem }

      it_behaves_like 'a container_item_factory'
    end
  end
end


