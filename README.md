# Fzip : Functional zippers for Ruby

To traverse and alter a hierarchical data structure in a functional way is best done using the "zipper" data structure as described originally by [Huet](http://www.st.cs.uni-saarland.de/edu/seminare/2005/advanced-fp/docs/huet-zipper.pdf).

`Fzip::Zipper` is a straight up port of the Clojure zip/zip library.

The Zipper can work with arbitrary hierarchical objects (trees). To do that it requires an adapter that implements three methods: `branch?(node)`, `children(node)`, and `create_node(node, children)`. An implementation for nested arrays is provided.

```ruby
zipper = Fzip.array(
  [
    ['x', '+', 'y'],
    '=',
    ['a', '/', 'b']
  ]
)

p zipper.down.right.right.down.right.replace(:foo).root
# >> [["x", "+", "y"], "=", ["a", :foo, "b"]]

p zipper.down.append_child(:bar).root
# >> [["x", "+", "y", :bar], "=", ["a", "/", "b"]]

p zipper.down.insert_child(:bar).down.right.insert_right(:baz).up.insert_left(:quux).root
# >> [:quux, [:bar, "x", :baz, "+", "y"], "=", ["a", "/", "b"]]
```

## Further reading

* [Wikipedia: Zipper (data structure)](https://en.wikipedia.org/wiki/Zipper_%28data_structure%29)
* [Three part article](http://pavpanchekha.com/blog/zippers/huet.html)

The Wikipedia page has more interesting links.