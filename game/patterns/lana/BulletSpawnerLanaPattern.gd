extends BulletSpawner


func _on_PatternTimer_timeout():
	for i in get_tree().get_nodes_in_group("stopbullets"):
		if is_instance_valid(i):
			i.velocity = Vector2(0, 0)


#override
func shoot(params={}):
	var bullet = DanmakuServer.instantiate_bullet(bullet_type)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * params.get("speedscale", 1)
	bullet.acceleration = bullet_acceleration
	bullet.add_to_group("stopbullets")
	owner.add_bullet(bullet) # This should lead to the SimpleBulletServer
