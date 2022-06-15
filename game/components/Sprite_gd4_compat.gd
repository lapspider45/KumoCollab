extends Sprite2D

# Godot 4 compatibility fix
var rotation_degrees:float = rad2deg(rotation):
	set(v):
		rotation_degrees = v
		rotation = deg2rad(v)
