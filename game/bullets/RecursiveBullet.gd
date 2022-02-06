extends SimpleBullet

export var wait_time := 1.2
export var ring_spokes := 8
export var sub_bullet : PackedScene = preload("res://game/bullets/LanaSparkleSprite.tscn")
export var speed := 80.0

func _on_shot():
	yield(timer(wait_time), "completed")
	
	spawn_subbullets()
	queue_free()

func advance(delta:float):
	.advance(delta)
	
	if !get_viewport_rect().has_point(position):
		bounce(get_viewport_rect())

func spawn_subbullets():
	Kumo.shoot_ring(sub_bullet.instance(), position, polar2cartesian(speed, velocity.angle() + deg2rad(15)), ring_spokes)
