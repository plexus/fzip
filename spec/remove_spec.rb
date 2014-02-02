require 'spec_helper'

describe Fzip::Zipper, 'remove' do
  let(:tree) {
    [
      ['x', '+', 'y'],
      ['a', '*', 'b']
    ]
  }

  let(:zipper) { Fzip.array(tree) }

  context 'when removing the top node' do
    it 'should raise an exception' do
      expect { zipper.remove }.to raise_error
    end
  end

  context 'when removing a node that has a left sibling' do
    let(:zipper) { super().down.down.right }

    it 'should remove the node' do
      expect(zipper.remove.root).to eq [
        ['x',      'y'],
        ['a', '*', 'b']
      ]
    end

    it 'should return the zipper pointing to the left sibling' do
      expect(zipper.remove.node).to eq 'x'
    end
  end

  context 'without left siblings' do
    let(:zipper) { super().down.down }

    it 'should remove the node' do
      expect(zipper.remove.root).to eq [
        [     '+', 'y'],
        ['a', '*', 'b']
      ]
    end

    it 'should point to the parent' do
      expect(zipper.remove.node).to eq [ '+', 'y' ]
    end

    context 'without right siblings' do
      let(:tree) {
        [
          [ 'z' ]
        ]
      }

      it 'should remove the node' do
        expect(zipper.remove.root).to eq [ [] ]
      end

      it 'should point to the parent node' do
        expect(zipper.remove.node).to eq []
      end
    end
  end

  context 'with left cousins' do
    let(:zipper) { super().down.right }

    it 'should remove the node' do
      expect(zipper.remove.root).to eq [ ['x', '+', 'y'] ]
    end

    it 'should point to the rightmost left cousin' do
      expect(zipper.remove.root).to eq [ ['x', '+', 'y'] ]
    end
  end

end
