#tool
class_name LanaBombSprite
extends SimpleBullet

var is_stopped := false

func advance(delta):
	if is_stopped:
		return
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta
	rotation += TAU * delta

func freeze():
	is_stopped = true
