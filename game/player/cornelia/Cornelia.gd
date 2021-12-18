extends "res://game/player/Player.gd"


var orbit_option = preload("res://game/player/cornelia/OrbitOption.tscn")
var orbit_options = []
var index := 0


func _ready():
	orbit_options.append(orbit_option.instance())
	orbit_options.append(orbit_option.instance())
	orbit_options.append(orbit_option.instance())


func _on_Cheat_pressed():
	if index == orbit_options.size():
		return
	add_child(orbit_options[index])
	index += 1
	for i in get_tree().get_nodes_in_group("orbitoption"):
		i.reset()
