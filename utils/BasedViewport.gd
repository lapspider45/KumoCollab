extends Viewport

export var actual_size = Vector2(360,640)

func _on_Viewport_size_changed():
	size = actual_size # wtf is this workaround


func _ready():
	var scene = get_child(0)
	Registry.register("current_gamescene", scene)
