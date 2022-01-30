extends Node2D

@export var hp = 10.0

func take_damage(dmg=1):
	pass
	hp -= dmg
	if hp <= 0:
		die()
	# give player score

func die():
	SFX.play("boom1")
	queue_free()
	pass
	# give player score
	# drop pickups

func _on_Hitbox_took_damage(value):
	take_damage(value)
