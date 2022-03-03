extends Area2D

export var damage_disabled := false
export var damage_multiplier := 1.0 # for making "weak spots"

signal took_damage(value)

func _init():
	connect("area_entered", self, "on_hit_by")

func on_hit_by(area:Area2D):
	if damage_disabled:
		return
	if area.get("damage") != null: # check if this node actually has the "damage" property
		area.call("on_hit_something", self) # notify the bullet that it hit something
		on_hit(area.get("damage") * damage_multiplier)

func on_hit(damage):
	emit_signal("took_damage", damage)
