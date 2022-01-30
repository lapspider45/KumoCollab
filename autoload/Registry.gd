extends Node

signal registry_updated
var node_registry := {}

# adds a node to the Registry, making it globally accessible
func register(_name:String, ref:Node):
	node_registry[_name] = ref
	emit_signal("registry_updated")
#	print_debug("registry updated: %s <- %s" % [name, ref])

func get_entry(_name:String):
	return node_registry.get(_name)

func wait_for_node(_name:String):
	while not node_registry.has(_name):
		await registry_updated
	# Godot4: is the following await unnecessary now?
	await get_tree().process_frame
	return node_registry[_name]
