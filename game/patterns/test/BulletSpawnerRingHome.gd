extends BulletSpawner

export var ring_size := 16

var bullet_parameters := {}

func push_bullet_param(_name:String, value):
	bullet_parameters[_name] = value

func pop_bullet_param(_name:String):
	return bullet_parameters.erase(_name)

func clear_bullet_param():
	bullet_parameters.clear()

func discoball():
	get_tree().call_group(bullet_group_id, "cycle_color")
	for c in children_spawners:
		c.call("discoball")

func shoot():
	shoot_ring(ring_size)
	rotate(3.0/12)

func shoot_hard():
	var orig_speed = bullet_speed
	var orig_time = bullet_template.get("wait_duration")
	var dupes = 3
	for i in range(dupes):
		shoot_ring(ring_size)
		bullet_template.set("wait_duration", orig_time * 1 - (i/float(dupes+2)))
		bullet_speed *= 0.85
	bullet_speed = orig_speed
	bullet_template.set("wait_duration", orig_time)
	rotate(3.0/12)

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

func _notification(what):
	._notification(what)


func update_children():
	children_spawners.clear()
	for c in get_children():
		if c.is_in_group("bulletspawner"):
			children_spawners.append(c)


func _init():
	add_to_group("bulletspawner")