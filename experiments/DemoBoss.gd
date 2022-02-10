extends "res://game/Enemy.gd"

func _ready():
	Registry.register("boss", self)
	Blackboard.boss = self

func on_spawn():
	invincible = false

func die():
	print("boss died")
	invincible = true
	Score.increment(400000)
	emit_signal("died")

func take_damage(dmg=1):
	if invincible: return
	SFX.play("hit")
	Score.increment(100 * dmg)
	.take_damage(dmg)

func _on_Hitbox_Main_took_damage(value):
	take_damage(value)

func _process(delta):
	Blackboard.boss_pos = position
