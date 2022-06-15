extends Area2D
@export var damage := 1.0

func _init():
	area_entered.connect(on_hit_something)

func on_hit_something(what:Area2D):
	what.call("on_hit", damage)
