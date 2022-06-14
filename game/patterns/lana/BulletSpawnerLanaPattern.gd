extends BulletSpawner

@export var explosion_amount := 2
@export var explosion_speed := 50
@export var explosion_acceleration := Vector2(0, 20)


#override
func shoot(params={}):
	var bullet = Kumo.instantiate_bullet(bullet_type)
	var velocity = bullet_speed * Vector2.from_angle(global_rotation) * params.get("speedscale", 1)
	bullet.acceleration = bullet_acceleration
	bullet.add_to_group("stopbullets")
	Kumo.shoot(bullet, global_position, velocity) # This should lead to the SimpleBulletServer


func _stop_bullet_to_explode():
	for i in get_tree().get_nodes_in_group("stopbullets"):
		if is_instance_valid(i):
			i.freeze()


func _bullets_explode():
	for i in get_tree().get_nodes_in_group("stopbullets"):
		if is_instance_valid(i):
			for _j in explosion_amount:
				var bullet = Kumo.instantiate_bullet("lana_sparkle")
				var random_direction := Vector2.from_angle(randf_range(0, TAU))
				bullet.acceleration = Vector2(0, 20)
				Kumo.shoot(bullet, i.global_position, explosion_speed * Vector2.from_angle(randf_range(0, TAU)))
			i.queue_free()
