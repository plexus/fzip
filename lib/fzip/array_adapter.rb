module Fzip
  class ArrayAdapter
    def branch?(node)
      node.respond_to? :to_ary
    end

    def children(node)
      node.empty? ? nil : node
    end

    def make_node(node, children)
      children
    end

  end
end
