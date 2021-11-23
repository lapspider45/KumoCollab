extends Label

func update():
#	var bullets = get_tree().get_nodes_in_group("bullets").size()
	var BULLETS = yield(Registry.wait_for_node("current_gamescene"), "completed").BULLETS
	var bullets = BULLETS.get_child_count()
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var frametime = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
	text = """bullets: %05d
	FPS: %03.1f
	frametime: %03.3f ms
	""" % [bullets, fps, frametime]
	text += """
	slowdown: %d
	deletion queue: %d
	
	""" % [BULLETS.num_batches, BULLETS.deletion_queue.size()]


func _ready():
	while true:
		update()
		yield(get_tree().create_timer(0.3), "timeout")
