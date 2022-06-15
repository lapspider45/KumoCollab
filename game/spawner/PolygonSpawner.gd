extends BulletSpawner

@export var edges:int = 3
@export var shots_p_edge:int = 6

func shoot_ngon(_edges:int, shots_per_edge:int, skip:int=1):
	assert(_edges >= 3)
	var points := []
	for i in range(_edges):
		var angle = global_rotation + (i/float(_edges) * TAU)
		var point = Vector2.from_angle(angle)
		points.append(point)
	for i in range(points.size()):
		var pointA:Vector2 = points[i]
		var pointB:Vector2 = points[(i + skip) % points.size()]
		for j in range(shots_per_edge):
			var shoot_direction := pointA.lerp(pointB, float(j)/shots_per_edge)
			shoot_velocity(bullet_speed * shoot_direction)


func shoot_star(corners:int, shots_per_edge:int):
	if corners % 2 == 1: # odd
		@warning_ignore(narrowing_conversion)
		shoot_ngon(corners, shots_per_edge, 0.5 * (corners-1))
	elif corners > 4:
		@warning_ignore(integer_division)
		shoot_star(corners/2, shots_per_edge)
		rotate(TAU/corners)
		@warning_ignore(integer_division)
		shoot_star(corners/2, shots_per_edge)
		rotate(-TAU/corners)
	else:
		shoot_ngon(corners, shots_per_edge)

func shoot():
	shoot_star(edges, shots_p_edge)
#	shoot_ring(40)


func shoot_velocity(velocity:Vector2):
	var bullet = bullet_template
	bullet.acceleration = bullet_acceleration
	bullet.lifetime = bullet_lifetime
	Kumo.shoot(bullet, global_position, velocity * speedscale)
	emit_signal("spawned", bullet)
