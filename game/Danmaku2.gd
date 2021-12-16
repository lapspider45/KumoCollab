extends Node2D

onready var player = $Player
onready var server = $SimpleBulletServer

var current_pattern : Node

func _ready():
	Registry.register("current_gamescene", self)
	$SimpleBulletServer.connect("bullet_collided", self, "on_collision")
	
	load_pattern("Easy")
	yield(get_tree().create_timer(4), "timeout")
	load_pattern("Medium")

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
	if current_pattern: current_pattern.queue_free()
	var pattern = load("res://game/patterns/".plus_file(ptn + ".tscn")).instance() # preloading or caching could be a plus
	add_child(pattern)
	current_pattern = pattern
