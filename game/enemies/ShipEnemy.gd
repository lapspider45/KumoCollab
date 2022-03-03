extends Enemy

export var bullet_acceleration = 100.0

func set_behavior(behavior:String):
	return
	if $behavior.is_playing():
		$behavior.play("RESET")
	$behavior.play(behavior)


func move_direction(vec:Vector2, delta:float):
	if enable_acceleration:
		rotation = velocity.angle()
	else:
		rotation = vec.angle()
	.move_direction(vec, delta)

func shoot():
	var g1 = $guns/BulletSpawner
	var g2 = $guns/BulletSpawner2
	g1.bullet_acceleration = polar2cartesian(bullet_acceleration, g1.global_rotation + TAU/6)
	g2.bullet_acceleration = polar2cartesian(bullet_acceleration, g2.global_rotation - TAU/6)
	for g in $guns.get_children():
		g._shoot()
