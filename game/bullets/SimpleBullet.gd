#tool
class_name SimpleBullet
extends Sprite

export var collision_radius := 1.0
export var radius := 1.0
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2


#func _draw():
#	if Engine.editor_hint:
#		draw_circle(Vector2.ZERO, collision_radius, Color(1, 0, 1, 0.5))

func advance(delta):
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta
