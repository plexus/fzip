require 'spec_helper'

describe Fzip::Zipper, 'next' do
  let(:tree) {
    [
      ['x', '+', 'y'],
      ['a', '*', 'b']
    ]
  }
  let(:zipper) { Fzip.array(tree) }

  let(:sequence) {
    [
      tree,
      ['x', '+', 'y'],
      'x',
      '+',
      'y',
      ['a', '*', 'b'],
      'a',
      '*',
      'b'
    ]
  }

  it 'should go depth first' do
    sequence.each.with_index do |n, idx|
      nth = (0...idx).inject(zipper) {|z| z.next}
      expect(nth.node).to eq n

      p nth.node
      sequence.first(idx+1).reverse.each.with_index do |p, pidx|
        puts " => #{p.inspect}"
        pth = (0...pidx).inject(nth) {|n| n.prev}
        expect(pth.node).to eq p
      end
    end
  end

  it 'should go to the end' do
    z = zipper
    9.times do
      expect(z.end?).to be_false
      z = z.next
    end
    expect(z.end?).to be_true
  end

end
