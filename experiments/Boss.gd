extends Node2D

signal phase_completed

var __spells = []
var seq_counter = 0
var game:Node
var current_pattern:Node

func _ready():
	add_spell("test1", preload("res://game/patterns/test/Crosswinds.tscn")).set_timeout(10.0)
	add_spell("test2", preload("res://game/patterns/test/RingsTest.tscn")).set_timeout(10.0)
	add_spell("test3", preload("res://game/patterns/lana/Hard1.tscn")).set_timeout(55.0)
	
	game = await Registry.wait_for_node("current_gamescene")
	
#	for spell_data in __spells:
#		load_spell(spell_data)
#		await phase_completed
	

func load_spell(spell:Dictionary):
	if is_instance_valid(current_pattern): current_pattern.queue_free()
	current_pattern = spell.get("spell").instantiate()
	game.add_child(current_pattern)
	
	current_pattern.start()
	Blackboard.pattern_timer.timeout.connect(pattern_timeout)
	Blackboard.start_timeout(spell.get("timeout", 99.0))

func pattern_timeout():
	emit_signal("phase_completed")

func add_spell(label:String, spell):
	var seq_id:int = seq_counter
	seq_counter += 1
	var sdata := SpellData.new(seq_id, label, spell)
	
	__spells.append(sdata.data)
	return sdata # RefCounted:s are supposed to be passed by reference, so you can edit it after the fact

func add_event(label:String, data:=[]): # events are used to trigger scripting inbetween spells
	pass

class SpellData extends RefCounted:
	var data : Dictionary
	
	func _init(seq_id:int, label:="", spell=null):
		data = {
			"seq": seq_id,
			"label": label,
			"spell": spell,
		}
	
	func set_timeout(time:float=99.0):
		data.timeout = time
		return self
	
	func set_hp(hp:float):
		data.hp = hp
		return self
	
	func set_userdata(d):
		data.user_data = d
		return self
