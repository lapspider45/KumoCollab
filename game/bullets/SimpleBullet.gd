#tool
class_name SimpleBullet
extends Sprite2D

signal tick

@export var radius := 1.0
@export var velocity:Vector2
@export var lifetime := 10.0
@export var acceleration:Vector2
@export var delete_outside_screen := true
@export var damage := 1.0 # how much damage this bullet deals, only affects bosses since player always gets oneshot

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
		await tick

func waitfor(end_time:float):
	assert(end_time >= 0.0, "Timer must complete before bullet times out")
	while lifetime > end_time:
		await tick


