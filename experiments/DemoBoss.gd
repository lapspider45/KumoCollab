extends "res://game/Enemy.gd"




func _on_Hitbox_Main_took_damage(value):
	SFX.play("hit")
	take_damage(value)
