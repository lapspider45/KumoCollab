extends SubViewport

#@export var actual_size = Vector2i(360,640)

func _on_Viewport_size_changed():
#	if size == actual_size:
#		return
#	size = actual_size # wtf is this workaround
	Blackboard.init_screen_rect(get_rect())

#func _ready():
#	var scene = get_child(0)
#	Registry.register("current_gamescene", scene)

func get_rect():
	return Rect2(Vector2.ZERO, size_2d_override)
