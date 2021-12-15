extends BulletSpawner

var bullet_parameters := {}

func push_bullet_param(_name:String, value):
	bullet_parameters[_name] = value

func pop_bullet_param(_name:String):
	return bullet_parameters.erase(_name)

func clear_bullet_param():
	bullet_parameters.clear()

func discoball():
	get_tree().call_group(bullet_group_id, "cycle_color")

func shoot():
	shoot_ring(16)
	
	rotate(TAU/12)


func shoot_single():
	var bullet = bullet_template.duplicate(DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * speedscale
	bullet.acceleration = bullet_acceleration
	
	for param in bullet_parameters:
		bullet.set(param, bullet_parameters[param])
	
	DanmakuServer.add_bullet(bullet)
	emit_signal("spawned", bullet)
