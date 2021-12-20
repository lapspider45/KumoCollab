extends Control


func _ready():
	OS.min_window_size = Vector2(480, 640) + Vector2(16,16) * 2


func _unhandled_key_input(event):
	if event.is_action_pressed("restart"):
		print("RESTARTING NOW!")
		get_tree().reload_current_scene()
