extends Area2D
export var damage := 1.0

func _init():
	connect("area_entered", self, "on_hit_something")

func on_hit_something(what:Area2D):
	what.call("on_hit", damage)
