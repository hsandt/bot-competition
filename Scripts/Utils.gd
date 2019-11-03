class_name Utils

# Candidate for generic helper function
# When using this inside a script, pass any node in the same tree as
#   the node you are looking for as `node_in_same_tree`
#   (in general, passing `self` is enough)
static func get_single_node_by_tag(node_in_same_tree: Node, tag: String):
	var group = node_in_same_tree.get_tree().get_nodes_in_group(tag)
	# will fail when playing Character prefab scene alone, don't do that!
	assert(not group.empty())
	return group[0]
