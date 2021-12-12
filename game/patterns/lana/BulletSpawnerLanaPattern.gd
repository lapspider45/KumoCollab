extends BulletSpawner

export var explosion_amount := 2
export var explosion_speed := 50
export var explosion_acceleration := Vector2(0, 20)


#override
func shoot(params={}):
	var bullet = DanmakuServer.instantiate_bullet(bullet_type)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * params.get("speedscale", 1)
	bullet.acceleration = bullet_acceleration
	bullet.add_to_group("stopbullets")
	DanmakuServer.add_bullet(bullet) # This should lead to the SimpleBulletServer


func _stop_bullet_to_explode():
	for i in get_tree().get_nodes_in_group("stopbullets"):
		if is_instance_valid(i):
			i.freeze()


func _bullets_explode():
	for i in get_tree().get_nodes_in_group("stopbullets"):
		if is_instance_valid(i):
			for _j in explosion_amount:
				var bullet = DanmakuServer.instantiate_bullet("lana_sparkle")
				bullet.set_as_toplevel(true)
				bullet.position = i.global_position
				var random_direction := Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))
				bullet.velocity = random_direction.rotated(global_rotation) * explosion_speed
				bullet.acceleration = Vector2(0, 20)
				DanmakuServer.add_bullet(bullet)
			i.queue_free()
