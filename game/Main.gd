extends Control


func _ready():
	OS.min_window_size = Vector2(480, 640) + Vector2(16,16) * 2
