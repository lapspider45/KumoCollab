extends "res://game/Enemy.gd"

func _ready():
	Registry.register("boss", self)
	Blackboard.boss = self

func on_spawn():
	invincible = false

func die():
	print("boss died")
	emit_signal("died")
	invincible = true

func take_damage(dmg=1):
	if invincible: return
	SFX.play("hit")
	.take_damage(dmg)

func _on_Hitbox_Main_took_damage(value):
	take_damage(value)

func _process(delta):
	Blackboard.boss_pos = position
