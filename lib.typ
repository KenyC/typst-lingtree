#import "intern.typ"

#let default-layer-spacing = 3em
#let default-child-spacing = 1em
#let global-defaults = (
	layer-spacing: default-layer-spacing,
	child-spacing: default-child-spacing,
	branch-stroke: (thickness: 0.75pt),
	color: none,
)


#let tree(
	tag: none,
	.. children,
	layer-spacing: none,
	child-spacing: none,
	branch-stroke: none,
	color: none,
	// if filled, defaults will be used for every node dominated by this one
	// if none, inherit defaults from parent
	// if none and tree is root, defaults is given by the `render' function
	defaults: none,
) = {
	// nodes are represented in reverse Polish notation
	// So, to merge multiple trees, we turn every content node (leaf) into a node of its own
	// we concatenate the result
	// (node1, node2, parentOf12) content (node3, node4, node5, parentOf345)
	// =>
	// (node1, node2, parentOf12, content, node3, node4, node5, parentOf345)
	// =>
	// (node1, node2, parentOf12, content, node3, node4, node5, parentOf345, parentOfThemAll)
	let flattened-nodes = children
		.pos()
		.map(c => 
			if type(c) == content 
			{ 
				(intern.new-node-info(c),)
			} 
			else {
				c
			}
		)
		.join()


	let new-node = intern.new-node-info(
		tag,
		n-children: children.pos().len(),
		layer-spacing: layer-spacing,
		child-spacing: child-spacing,
		branch-stroke: branch-stroke,
		color: color,
	)
	flattened-nodes.push(new-node)
	intern.resolve-defaults(flattened-nodes, defaults)
}




#let render(
	tree,
	defaults: global-defaults,
) = context {
	// First, we fill in all values for layer-spacing and child-spacing if they haven't been specified by intermediate nodes
	let tree = intern.resolve-defaults(tree, global-defaults + defaults)

	/// Second, we define series of stacks
	let stack = ()
	// Each element of the stack meets the template:
	// (
	//     content         : ...,
	//     root-x-position : ...,
	//     tag-empty       : ..., // whether the node is an empty tag or not
	// )

	for node in tree {
		if type(node) == dictionary {
			let n-children = node.n-children

			if n-children == 0 {
				let (tag, color,) = node
				if color != none {
					tag = text(color, tag)
				}
				let width = measure(tag).width
				stack.push((
					content:         tag,
					root-x-position: width / 2,
					tag-empty:       false,
				))
			}
			else {

				let children = stack.slice(-n-children)
				for _ in array.range(n-children) {
					let _ = stack.pop();
				};


				let rendered-node = intern.render-node(node, children);


				stack.push(rendered-node);
			}

		}
		else {
			panic("Wrong argument type");
		}
	};

	return stack.first().content
}

