require 'spec_helper'
require 'encase'

class EmptyBox
end

class Box
  include Encase

  needs :apples, :mangoes
  needs :oranges
end

describe 'Encaseable' do
  let(:box) { Box.new }
  let(:empty_box) { EmptyBox.new }

  it 'creates accessors if needs are specified' do
    expect(Box).to respond_to(:needs_to_inject)
    expect(box).to respond_to(:container)
    expect(box).to respond_to(:apples)
    expect(box).to respond_to(:mangoes)
    expect(box).to respond_to(:oranges)
  end

  it 'does not create accessors if needs are not specified' do
    expect(EmptyBox).to_not respond_to(:needs_to_inject)
    expect(empty_box).to_not respond_to(:container)
    expect(empty_box).to_not respond_to(:apples)
    expect(empty_box).to_not respond_to(:mangoes)
    expect(empty_box).to_not respond_to(:oranges)
  end

  it 'stores provided dependencies for later lookup' do
    expect(box.class.needs_to_inject).to match_array([:apples, :mangoes, :oranges])
  end
end
