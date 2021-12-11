#tool
class_name LanaBombSprite
extends Sprite


export var collision_radius := 1.0
export var radius := 10.0
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2
var is_stopped := false


func advance(delta):
	if is_stopped:
		return
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta
	rotation_degrees += 360 * delta


func freeze():
	is_stopped = true
