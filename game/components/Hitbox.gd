extends Area2D

@export var damage_disabled := false
@export var damage_multiplier := 1.0 # for making "weak spots"

signal took_damage(value)

func _init():
	area_entered.connect(on_got_hit)

func on_got_hit(by:Area2D):
	if damage_disabled:
		return
	if by.get("damage") != null: # check if this node actually has the "damage" property
		by.call("on_hit") # notify the bullet that it hit something
		emit_signal("took_damage", by.get("damage") * damage_multiplier)


