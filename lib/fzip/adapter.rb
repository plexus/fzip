module FZip
  class Adapter
    # Can the node have children
    #
    # Returns true if the node can have even if it currently doesn't.
    def branch?(node)
    end

    # The children of a node
    #
    # Return an array, or an object that responds to first, drop and +
    def children(node)
    end

    # Given a node and an array of children, returns a new branch node of the
    # same type with the supplied children.
    def make_node(node, children)
    end
  end
end
