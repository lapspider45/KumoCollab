extends SimpleBullet

@export var wait_time := 1.2
@export var ring_spokes := 8
@export var sub_bullet : PackedScene = preload("res://game/bullets/LanaSparkleSprite.tscn")
@export var speed := 80.0

func _on_shot():
	await timer(wait_time)
	
	spawn_subbullets()
	queue_free()

func advance(delta:float):
	super(delta)
	
	if !get_viewport_rect().has_point(position):
		bounce(get_viewport_rect())

func spawn_subbullets():
	Kumo.shoot_ring(sub_bullet.instantiate(), position, speed * Vector2.from_angle(velocity.angle() + deg2rad(15)), ring_spokes)
