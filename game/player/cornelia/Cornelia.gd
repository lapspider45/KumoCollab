extends "res://game/player/Player.gd"


var orbit_option = preload("res://game/player/cornelia/OrbitOption.tscn")
var orbit_options = []
var index := 0


func _ready():
	orbit_options.append(orbit_option.instance())
	orbit_options.append(orbit_option.instance())
	orbit_options.append(orbit_option.instance())
	
	_on_Cheat_pressed()
	_on_Cheat_pressed()
	
	for o in orbit_options:
		o.connect("spawned", self, "_on_bullet_shot")


func _on_Cheat_pressed():
	if index == orbit_options.size():
		return
	add_child(orbit_options[index])
	index += 1
	for i in get_tree().get_nodes_in_group("orbitoption"):
		i.reset()

func _on_bullet_shot(bullet):
	var vrect := get_viewport_rect()
	var pan_position := 2 * (inverse_lerp(vrect.position.x, vrect.end.x, position.x) - 0.5)
	SFX.play("shoot1", pan_position)
