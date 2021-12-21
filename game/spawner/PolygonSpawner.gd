extends BulletSpawner

export var edges:int = 3
export var shots_p_edge:int = 6

func shoot_ngon(edges:int, shots_per_edge:int, skip:int=1):
	assert(edges >= 3)
	var points := []
	for i in range(edges):
		var angle = global_rotation + (i/float(edges) * TAU)
		var point = Vector2.RIGHT.rotated(angle)
		points.append(point)
	for i in range(points.size()):
		var pointA:Vector2 = points[i]
		var pointB:Vector2 = points[(i + skip) % points.size()]
		for j in range(shots_per_edge):
			var shoot_direction := pointA.linear_interpolate(pointB, float(j)/shots_per_edge)
			shoot_velocity(bullet_speed * shoot_direction)


func shoot_star(corners:int, shots_per_edge:int):
	if corners % 2 == 1: # odd
		shoot_ngon(corners, shots_per_edge, 0.5 * (corners-1))
	elif corners > 4:
		shoot_star(corners/2, shots_per_edge)
		rotate(TAU/corners)
		shoot_star(corners/2, shots_per_edge)
		rotate(-TAU/corners)
	else:
		shoot_ngon(corners, shots_per_edge)

func shoot():
	shoot_star(edges, shots_p_edge)
#	shoot_ring(40)


func shoot_velocity(velocity:Vector2):
	var bullet = bullet_template.duplicate(DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = velocity * speedscale
	bullet.acceleration = bullet_acceleration
	bullet.lifetime = bullet_lifetime
	DanmakuServer.add_bullet(bullet)
	emit_signal("spawned", bullet)
