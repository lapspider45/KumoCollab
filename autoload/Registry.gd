extends Node

signal registry_updated
var node_registry := {}

# adds a node to the Registry, making it globally accessible
func register(_name:String, ref:Node):
	node_registry[_name] = ref
	emit_signal("registry_updated")
#	print_debug("registry updated: %s <- %s" % [name, ref])

func get_entry(name:String):
	return node_registry.get(name)

func wait_for_node(name:String):
	while not node_registry.has(name):
		yield(self, "registry_updated")
	yield(get_tree(), "idle_frame") # In godot 4, this line can be removed...
	return node_registry[name]
