extends Label

func update():
#	var bullets = get_tree().get_nodes_in_group("bullets").size()
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var frametime = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
	text = """
	FPS: %03.1f
	frametime: %03.3f ms
	""" % [fps, frametime]
	
	var BULLETS = DanmakuServer.current_server
	if !is_instance_valid(BULLETS):
		return

	text += """
	bullets: %05d
	slowdown: %d
	deletion queue: %d
	
	""" % [BULLETS.get_child_count(), BULLETS.num_batches, BULLETS.deletion_queue.size()]


func _ready():
	while true:
		update()
		yield(get_tree().create_timer(0.3), "timeout")
