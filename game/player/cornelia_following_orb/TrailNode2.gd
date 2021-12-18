extends Node2D


func _ready():
	for i in get_child_count():
		get_child(i).index = i


func _on_Trail_position_set(position, index, _z_index):
	if index == 6:
		return
	get_child(index).set_new_position(position, _z_index)


func set_new_position(position, _z_index):
	_on_Trail_position_set(position, 0, _z_index)
