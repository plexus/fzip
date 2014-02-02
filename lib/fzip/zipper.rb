module Fzip
  class Zipper
    attr_reader :adapter
    attr_reader :parent
    attr_reader :path
    attr_reader :node
    attr_reader :lefts
    attr_reader :rights
    attr_reader :at_end

    def initialize(adapter, node, lefts = nil, path = nil, parent = nil, rights = nil, changed = false, at_end = false)
      @adapter   = adapter

      @node      = node
      @lefts     = lefts
      @rights    = rights

      @path      = path    # Array[Node]
      @parent    = parent  # Zipper
      @changed   = changed
      @at_end    = at_end
    end

    def new(changes = {})
      self.class.new(
        @adapter,
        changes.fetch(:node)    { self.node     },
        changes.fetch(:lefts)   { self.lefts    },
        changes.fetch(:path)    { self.path     },
        changes.fetch(:parent)  { self.parent   },
        changes.fetch(:rights)  { self.rights   },
        changes.fetch(:changed) { self.changed? },
        changes.fetch(:end)     { self.end?     }
      )
    end

    def branch?
      adapter.branch?(node)
    end

    def children
      raise "called children on a leaf node" unless branch?
      @cs ||= adapter.children(node)
    end

    def make_node(node, children)
      adapter.make_node(node, children)
    end

    def changed?
      @changed
    end

    def end?
      @at_end
    end

    def down
      if branch? && children.any?
        new(
          node: children.first,
          lefts: [],
          path: path ? [node] + path : [node],
          parent: self,
          rights: children.drop(1)
        )
      end
    end

    def up
      if path
        return parent unless changed?
        parent_path = path.drop(1)
        new(
          node:   make_node(parent.node, lefts + [node] + rights),
          lefts:  parent.lefts,
          path:   parent_path.empty? ? nil : parent_path,
          parent: parent.parent,
          rights: parent.rights
        )
      end
    end

    def root
      return node unless path
      up.root
    end

    def right
      if path && rights && !rights.empty?
        new(
          node:   rights.first,
          lefts:  lefts + [node],
          rights: rights.drop(1)
        )
      end
    end

    def rightmost
      return self unless path && rights && !rights.empty?
      new(
        node: rights.last,
        lefts: (lefts + [node] + rights)[0..-2],
        rights: []
      )
    end

    def left
      if path && lefts && !lefts.empty?
        new(
          node:   lefts.last,
          lefts:  lefts[0...-1],
          rights: [node] + rights
        )
      end
    end

    def leftmost
      return self unless path && lefts && !lefts.empty?
      new(
        node: lefts.first,
        lefts: [],
        rights: (lefts + [node] + rights).drop(1)
      )
    end

    def insert_left(item)
      raise "insert at top" unless path
      new(
        lefts:   lefts + [item],
        changed: true
      )
    end

    def insert_right(item)
      raise "insert at top" unless path
      new(
        rights:  [item] + rights,
        changed: true
      )
    end

    def replace(item)
      new(
        node: item,
        changed: true
      )
    end

    def edit
      replace(yield node)
    end

    def insert_child(item)
      replace(make_node(node, [item] + children))
    end

    def append_child(item)
      replace(make_node(node, children + [item]))
    end

    def next
      backtrack = ->(node) {
        if node.up
          node.up.right || backtrack.(node.up)
        else
          node.new(end: true)
        end
      }

      (self if end?) ||
        (branch? && down) ||
        right ||
        backtrack.(self)
    end

    # def prev
    # end

    # Removes the node at loc, returning the loc that would have preceded
    # it in a depth-first walk.
    def remove
      raise "Remove at top" unless path
      if lefts.empty?
        parent.new(
          node: make_node(parent.node, rights),
          changed: true
        )
      else
        loc = new(
          node: lefts.first,
          lefts: lefts.drop(1),
          changed: true
        )
        loop do
          return loc unless child = loc.branch? && loc.down
          loc = child.rightmost
        end
      end
    end

    def each
      return to_enum unless block_given?
      loc = self
      until (loc = loc.next).end?
        yield loc
      end
    end
  end
end

# Notes on the port from zip.clj :
# Gave these variables a different name
#   pnodes => path
#   ppath  => parent
