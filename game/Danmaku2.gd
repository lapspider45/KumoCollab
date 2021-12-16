extends Node2D

onready var player = $Player
onready var server = $SimpleBulletServer

var current_pattern : Node

func _ready():
	Registry.register("current_gamescene", self)
	server.connect("bullet_collided", self, "on_collision")
	
	yield(demo_pattern_dir("lana", 10), "completed")
	yield(demo_pattern_dir("test", 10), "completed")
	print("all done!")
	current_pattern.queue_free()
#	load_pattern("test/SineFieldTest")
#	yield(get_tree().create_timer(15), "timeout")
#	load_pattern("lana/Hard1")

func _process(delta):
	var slowdown:float = $SimpleBulletServer.get_slowdown()
	Blackboard.slowdown = slowdown
	
	server.process_bullets(delta)
	get_tree().call_group("TickedAnimationPlayer", "advance", delta * slowdown)
	if player:
		player.advance(delta * slowdown)

func on_collision(_bullet):
#	print("collision with %s!" % bullet)
	$SimpleBulletServer.clear_bullets()
	if current_pattern: 
		current_pattern.reset()

func load_pattern(ptn:String):
	if current_pattern:
		current_pattern.stop()
		current_pattern.queue_free()
	if !ptn.ends_with(".tscn"):
		ptn += ".tscn"
	var pattern = load("res://game/patterns/".plus_file(ptn)).instance() # preloading or caching could be a plus
	add_child(pattern)
	current_pattern = pattern
	server.clear_bullets()
	current_pattern.start()


func demo_pattern_dir(dir:String, time:float):
	var dirpath = "res://game/patterns/".plus_file(dir)
	print("Demoing %s" % dirpath)
	var D = DirUtils.new()
	D.open(dirpath)
	for pattern in D.ls(): if pattern.name.ends_with(".tscn"):
		print("Demoing pattern: %s" % pattern.name)
		load_pattern(dir.plus_file(pattern.name))
		yield(get_tree().create_timer(time), "timeout")
