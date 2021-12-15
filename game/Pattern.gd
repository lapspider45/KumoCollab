class_name Pattern
extends Node2D

signal finished



func start():
	pass

func stop():
	pass

func reset():
	pass




func _register():
	Registry.register("current_pattern", self)

func _finish():
	emit_signal("finished")
