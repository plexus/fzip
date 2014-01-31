
module Fzip
  def self.array(node)
    Zipper.new(ArrayAdapter.new, node)
  end
end

require_relative 'fzip/array_adapter'
require_relative 'fzip/zipper'
