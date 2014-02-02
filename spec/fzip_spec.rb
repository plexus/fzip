require 'spec_helper'

describe Fzip, 'array' do
  let(:tree) {
    [
      ['x', '+', 'y'],
      ['a', '*', 'b']
    ]
  }

  let(:zipper) { Fzip.array(tree) }

  it 'should return a zipper suitable for arrays' do
    expect(zipper.adapter).to be_an_instance_of(Fzip::ArrayAdapter)
  end

  it 'should allow navigating' do
    expect(zipper.down.down.right.right.left.node).to eq('+')
  end

  it 'should allow inserting nodes' do
    expect(zipper.down.down.right.insert_left(:foo).insert_right(:bar).root).to eq [["x", :foo, "+", :bar, "y"], ["a", "*", "b"]]
  end

  it 'should allow replacing nodes' do
    expect(zipper.down.right.down.right.replace(:foo).root).to eq [["x", "+", "y"], ["a", :foo, "b"]]
  end

  it 'should allow editing with a block' do
    expect(zipper.down.right.down.right.edit{:foo}.root).to eq [["x", "+", "y"], ["a", :foo, "b"]]
  end
end
