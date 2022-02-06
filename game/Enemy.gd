extends Node2D

signal died

export var hp := 10.0
export var invincible := false

func take_damage(dmg=1):
	if invincible: return
	hp -= dmg
	if hp <= 0:
		die()
	# give player score

func die():
	SFX.play("boom1")
	queue_free()
	emit_signal("died")
	# give player score
	# drop pickups

func _on_Hitbox_took_damage(value):
	if invincible: return
	take_damage(value)
