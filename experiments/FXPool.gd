class_name FXPool
extends Node

var index = 0

func next():
	if get_child_count() == 0:
		return
	var i = index
	index = (index+1) % get_child_count()
	return get_child(i)
	

func create_pool(size:int): # virtual
	pass

func clear_pool():
	for c in get_children():
		c.queue_free()
