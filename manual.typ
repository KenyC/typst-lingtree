#import "@local/lingtree:1.0.0"
#import "@preview/tidy:0.4.1"

#show heading.where(level: 1): set align(center)
#set document(
  title: [_lingtree_],
  author: "Keny Chatain",
)
#let VERSION = toml("typst.toml").package.version


#title()

#align(center, [
	A Typst package for drawing linguistic tree.

	v#VERSION
])

= Usage

Here is a simple example:

#let example-tree-code = "
#render(
  tree(
    tag: [VP],
    tree(
      tag: [DP],
      [every],
      tree(
          tag: [NP],
          [farmer],
          tree(
            tag: [CP],
            [who],
            tree(
              tag: [VP],
              [owns],
              tree(
                tag: [DP],
                [a], [donkey],
                defaults: (color: blue),
              )
            )
          )
      )
    ),
    tree(
      tag: [VP],
      [likes], text(blue)[it],
    ),
  )
)

"

#table(
	columns: 2,
	stroke: none,
	// align: horizon,
	raw(
		example-tree-code,
		lang: "typst",
	),
	box(eval(
		example-tree-code, 
		mode: "markup", 
		scope: (
			tree:   lingtree.tree,
			render: lingtree.render,
		)
	)),
)


= Reference


#let docs = tidy.parse-module(read("lib.typ"), scope: (lingtree: lingtree))
#tidy.show-module(docs, style: tidy.styles.default)