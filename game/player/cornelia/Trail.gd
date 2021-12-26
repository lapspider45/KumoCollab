extends Sprite

var last_movement := []
var last_z_index := []
onready var has_trail := true
signal position_set(_position, _index, current_z_index)
var index := 0


func _ready():
	# aha, so this is a buffer which delays the movement by 6 frames...
	for i in 6 :
		last_movement.append(Vector2.ZERO)
		last_z_index.append(0)

func set_new_position(value, _z_index):
	last_movement.push_front(value)
	var delayed_movement = last_movement.pop_back()
	position = delayed_movement
	last_z_index.push_front(_z_index)
	z_index = last_z_index.pop_back()
	if has_trail:
		emit_signal("position_set", position, index + 1, z_index)
		return
