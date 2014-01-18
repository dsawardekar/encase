require 'spec_helper'
require 'encase/container'
require 'encase'

module Encase
  class Lorem
  end

  class MyBox
    include Encase

    needs :apples, :mangoes
    needs :oranges
  end

  describe Container do
    let(:container) {
      Container.new
    }

    it 'can store objects' do
      container.object(:lorem, 'lorem')
      expect(container.lookup(:lorem)).to eq('lorem')
    end

    it 'can store factories' do
      container.factory(:lorem, Lorem)
      expect(container.lookup(:lorem)).to be_a(Lorem)
    end

    it 'can store singletons' do
      container.singleton(:lorem, Lorem)
      instance1 = container.lookup(:lorem)
      instance2 = container.lookup(:lorem)

      expect(instance1).to eq(instance2)
    end

    it 'can be configured with a DSL' do
      container.configure do
        object :lorem, 'lorem'
        factory :lipsum, Lorem
        singleton :dolor, Lorem
      end

      expect(container.lookup(:lorem)).to eq('lorem')
      expect(container.lookup(:lipsum)).to be_a(Lorem)

      instance1 = container.lookup(:dolor)
      instance2 = container.lookup(:dolor)

      expect(instance1).to eq(instance2)
    end

    it 'raises a KeyError for unknown keys' do
      expect {
        container.lookup(:unknown_key)
      }.to raise_error(KeyError)
    end

    it 'can create nested containers' do
      child = container.child()
      grand_child = child.child()

      expect(grand_child.parent).to eq(child)
      expect(child.parent).to eq(container)
      expect(container.parent).to be_nil
    end

    it 'can lookup values from nested containers' do
      child = container.child()
      grand_child = child.child()

      container.object(:lorem, 'in_container')
      child.object(:lorem, 'in_child')
      grand_child.object(:lorem, 'in_grand_child')

      expect(grand_child.lookup(:lorem)).to eq('in_grand_child')

      grand_child.unregister(:lorem)
      expect(grand_child.lookup(:lorem)).to eq('in_child')

      child.unregister(:lorem)
      expect(grand_child.lookup(:lorem)).to eq('in_container')
    end

    it 'can clear the container store' do
      container.object(:lorem, 'lorem')
      container.object(:ipsum, 'ipsum')
      container.object(:dolor, 'dolor')

      container.clear

      expect(container.contains?(:lorem)).to be_false
      expect(container.contains?(:ipsum)).to be_false
      expect(container.contains?(:dolor)).to be_false
    end

    it 'can inject dependencies' do
      container.configure do
        object :apples, 10
        object :mangoes, 20
        object :oranges, 30
        factory :box, MyBox
      end

      box = container.lookup(:box)
      expect(box.apples).to eq(10)
      expect(box.mangoes).to eq(20)
      expect(box.oranges).to eq(30)
    end

    it 'can inject dependencies lazily' do
      container.configure do
        object :apples, -> { 10 }
        object :mangoes, -> { 20 }
        object :oranges, -> { 30 }
        factory :box, -> { MyBox }
      end

      box = container.lookup(:box)
      expect(box.apples).to eq(10)
      expect(box.mangoes).to eq(20)
      expect(box.oranges).to eq(30)
    end

    it 'assigns container on injection' do
      class DummyObjectToBeInjected
        include Encase
        needs :lorem
      end

      container.object(:lorem, 'lorem')
      container.factory(:dummy, DummyObjectToBeInjected)

      dummy = container.lookup(:dummy)
      expect(dummy.container).to eq(container)
    end

    it 'call on_inject hook after injection' do
      class DummyWithOnInject
        include Encase
        needs :lorem
        attr_accessor :injected

        def on_inject
          self.injected = true
        end
      end

      container.object(:lorem, 'lorem')
      container.factory(:dummy, DummyWithOnInject)

      dummy = container.lookup(:dummy)
      expect(dummy.injected).to be_true
    end

    context 'Performance', :benchmark => true do
      require 'benchmark'

      it 'can store 100s of dependencies quickly' do
        runtime = Benchmark.realtime do
          container.configure do
            10000.times do |i|
              item = "item#{i}"
              object item.to_sym, item
            end
          end
        end

        expect(runtime).to be < 0.1
      end

      it 'can lookup 100s of dependencies quickly' do
        class ClassWithManyDeps
          include Encase

          100.times do |i|
            needs "item#{i}".to_sym
          end
        end

        container.configure do
          100.times do |i|
            item = "item#{i}"
            object item.to_sym, item
          end

          factory :lorem, ClassWithManyDeps
        end

        runtime = Benchmark.realtime do
          100.times do |i|
            container.lookup(:lorem)
          end
        end

        expect(runtime).to be < 0.1
      end
    end

    context 'Needs with class inheritance' do
      it 'can recognize needs in parent class' do
        class MyGrandParent
          include Encase
          needs :a
        end

        class MyParent < MyGrandParent
          include Encase
          needs :b
        end

        class MyChild < MyParent
          include Encase
          needs :c
        end

        class MyGrandChild < MyChild
        end

        container.configure do
          object :a, 'A'
          object :b, 'B'
          object :c, 'C'

          factory :me, MyGrandChild
        end

        me = container.lookup(:me)
        expect(me.a).to eq('A')
        expect(me.b).to eq('B')
        expect(me.c).to eq('C')
      end
    end
  end
end
