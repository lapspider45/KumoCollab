extends Node2D


func _ready():
	for i in get_child_count():
		get_child(i).index = i


func _on_Trail_position_set(_position, index, _z_index):
	if index == 6:
		return
	get_child(index).set_new_position(_position, _z_index)


func set_new_position(_position, _z_index):
	_on_Trail_position_set(_position, 0, _z_index)
