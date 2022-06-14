extends Enemy

func _ready():
	Registry.register("boss", self)
	Blackboard.boss = self

func on_spawn(_data=null):
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
	super(dmg)

func _on_Hitbox_Main_took_damage(value):
	take_damage(value)

func _process(_delta):
	Blackboard.boss_pos = position
