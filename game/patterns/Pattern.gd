class_name Pattern
extends Node2D

signal finished



func start():
	pass

func stop():
	pass

func reset():
	pass
	print("unimplemented pattern reset")

func set_difficulty(d:float):
	pass
#	if d < 1.0:
#		print("difficulty is easy")
#	elif d < 2.0:
#		print("difficulty is normal")
#	elif d < 3.0:
#		print("difficulty is hard")
#	elif d < 3.14:
#		print("fractional difficulty is possible, but optional to implement")


func _register():
	Registry.register("current_pattern", self)

func _finish():
	emit_signal("finished")


func make_remotetransform2d(source:Node2D, target:Node2D=self)-> RemoteTransform2D:
	return RemoteTransform2D.new() # TODO: temp disabled
#	if !is_instance_valid(source):
#		push_error("no source for remotetransform2d!!")
#		return RemoteTransform2D.new()
#	var rxform = RemoteTransform2D.new()
#	rxform.update_rotation = false
#	rxform.update_scale = false
#	source.add_child(rxform)
#	rxform.remote_path = target.get_path()
#
#	return rxform
