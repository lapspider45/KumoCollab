class_name SimpleBullet
extends Sprite

signal tick

export var radius := 1.0
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2
export var delete_outside_screen := true
export var damage := 1.0 # how much damage this bullet deals, only affects bosses since player always gets oneshot

#func _draw():
#	if Engine.editor_hint:
#		draw_circle(Vector2.ZERO, radius, Color(1, 0, 1, 0.5))

func advance(delta):
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta
	emit_signal("tick")
	
#	rotate(delta)
	
	if lifetime < 0:
		queue_free()


func timer(time:float):
	var end_time = lifetime - time
	assert(end_time >= 0.0, "Timer must complete before bullet times out")
	while lifetime > end_time:
		yield(self, "tick")

func waitfor(end_time:float):
	assert(end_time >= 0.0, "Timer must complete before bullet times out")
	while lifetime > end_time:
		yield(self, "tick")

# Called when the bullet instance is shot.
func _on_shot():
	pass

func bounce(rect:Rect2):
	if position.x < rect.position.x:
		velocity = velocity.bounce(Vector2.RIGHT)
	elif position.x > rect.end.x:
		velocity = velocity.bounce(Vector2.LEFT)
	if position.y < rect.position.y:
		velocity = velocity.bounce(Vector2.DOWN)
	elif position.y > rect.end.y:
		velocity = velocity.bounce(Vector2.UP)
