extends Node2D

signal phase_completed
signal boss_defeated

var game:Node
var current_pattern:Node

var spells = [
	{
		title = "Spell name circular",
		spell = preload("res://game/patterns/lana/EasyLanaCircular.tscn"),
		timeout = 30,
		hp = 300,
#		animation = "phase1_movement",
	},
	{
		title = "Lana medium 1",
		spell = preload("res://game/patterns/lana/Medium1.tscn"),
		timeout = 30,
		animation = "phase1_movement",
		hp = 500,
	},
	{
		spell = preload("res://game/patterns/test/SineFieldTest.tscn"),
		hp = 150, # with no "hp" property, you are forced to time this spell out
		timeout = 20,
		delay = 3,
		animation = "test_movement"
	},
	{
		spell = preload("res://game/patterns/lana/LanaRecursive.tscn"),
		hp = 500,
		delay = 2,
		timeout = 45,
		animation = "test_movement"
	}
]

func _init():
	validate_spells()

func _ready():
	game = yield(Registry.wait_for_node("current_gamescene"), "completed")
	
	for spell_data in spells:
		yield(play_spell(spell_data), "completed")
	emit_signal("boss_defeated")
	print("game over")
	$DemoBoss.queue_free()
	if current_pattern: current_pattern.queue_free()
	

func play_spell(spell:Dictionary):
	if is_instance_valid(current_pattern):
		current_pattern.queue_free()
	
	var delay = spell.get("delay", -1)
	if delay > 0:
		yield(get_tree().create_timer(delay), "timeout")
	
	current_pattern = spell.spell.instance()
	game.add_child(current_pattern)
	
	# setup the health for the spell
	var BossEnemy = $DemoBoss
	if spell.has("hp"):
		BossEnemy.connect("died", self, "on_spell_defeated", [BossEnemy])
		BossEnemy.hp = spell.hp
		BossEnemy.on_spawn()
		Blackboard.show_healthbar_for(BossEnemy, spell.hp)
	else:
		Blackboard.boss_healthbar.hide()
	
	
	# setup the timeout for the spell
	Blackboard.pattern_timer.connect("timeout", self, "pattern_timeout")
	Blackboard.start_timeout(spell.get("timeout", 99.0))
	
	if spell.has("animation"):
		$AnimationPlayer.play(spell.get("animation"))
	else:
		$AnimationPlayer.stop(false)
	
	current_pattern.start()
	
	yield(self, "phase_completed")
	Blackboard.stop_timeout()
	Blackboard.pattern_timer.disconnect("timeout", self, "pattern_timeout")
	if BossEnemy.is_connected("died", self, "on_spell_defeated"):
		BossEnemy.die()
		BossEnemy.disconnect("died", self, "on_spell_defeated")

func on_spell_defeated(emitter):
	emitter.disconnect("died", self, "on_spell_defeated")
	emit_signal("phase_completed")

func pattern_timeout():
	emit_signal("phase_completed")

func validate_spells():
	for s in spells:
		assert(s.get("spell") is PackedScene, "Tried to add a phase with no attached spell!")
		assert(s.has("hp") or s.has("timeout"), "Spell has to have at least one of 'hp' or 'timeout'!")
