extends Node2D

var current_pattern : Node

var popper:Node

func _ready():
	Registry.register("current_gamescene", self)
	Kumo.connect("bullet_collided", self, "on_collision")
	
	popper = yield(Registry.wait_for_node("LabelPopper"), "completed")

func _process(delta):
	var slowdown:float = Kumo.get_slowdown()
	Blackboard.slowdown = slowdown
	
	Kumo.process_bullets(delta)
	get_tree().call_group("TickedAnimationPlayer", "advance", delta * slowdown)
	get_tree().call_group("autoadvance", "advance", delta * slowdown)
	for player in get_tree().get_nodes_in_group("player"):
		player.advance(delta * slowdown)

func on_collision(_bullet):
#	print("collision with %s!" % bullet)
	# this isn't the best way to find the player...
	for p in get_tree().get_nodes_in_group("player"):
		p.on_hit()

func load_pattern(ptn:String):
	if is_instance_valid(current_pattern):
		current_pattern.stop()
		current_pattern.queue_free()
	if !ptn.ends_with(".tscn"):
		ptn += ".tscn"
	ptn = ptn.trim_prefix("res://game/patterns/")
	var packed:PackedScene = load("res://game/patterns/".plus_file(ptn))
	var pattern = packed.instance() # preloading or caching could be a plus
	add_child(pattern)
	current_pattern = pattern
	Kumo.clear_bullets()
	current_pattern.start()


func demo_pattern_dir(dir:String, time:float):
	var dirpath = "res://game/patterns/".plus_file(dir)
	print("Demoing %s" % dirpath)
	var D = DirUtils.new()
	D.open(dirpath)
	for pattern in D.ls(): if pattern.name.ends_with(".tscn"):
		print("Demoing pattern: %s" % pattern.name)
		load_pattern(dir.plus_file(pattern.name))
		yield(Blackboard.start_timeout(time), "completed")
		current_pattern.stop()
		yield(get_tree().create_timer(1.5), "timeout")
