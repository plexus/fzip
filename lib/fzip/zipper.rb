module Fzip
  class Zipper
    attr_reader :adapter, :parent, :path, :node, :lefts, :rights, :at_end

    def initialize(adapter, node, lefts = nil, path = nil, parent = nil, rights = nil, changed = false, at_end = false)
      @adapter   = adapter
      @node      = node
      @lefts     = lefts
      @path      = path
      @parent    = parent
      @rights    = rights
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
      if branch? && children
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
          node:   make_node(node, lefts + [node] + rights),
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

    #def rightmost

    def left
      if path && lefts && !lefts.empty?
        new(
          node:   lefts.last,
          lefts:  lefts[0...-1],
          rights: [node] + rights
        )
      end
    end

    # def leftmost

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

    # def remove

    def each
      return to_enum unless block_given?
      loc = self
      until (loc = loc.next).end?
        yield loc
      end
    end
  end
end
