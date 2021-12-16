extends BulletSpawner

var shot_idx = 0

var the_point = Vector2()

export var seq_id = 0

func _process(delta):
	look_at(the_point)
	rotate(PI)

func shoot():
	
	var next_color = shot_idx % 8
	if bullet_template is SimpleBullet:
		bullet_template.set_color(next_color)
	
	accelerate_towards_point(the_point, 160)
	
	shot_idx += 1
	match seq_id:
		0: shoot_ring(7)
		1: shoot_ray_ring(6, 4, 0.5, 2.5)
		2: shoot_arc(10, deg2rad(120))
		3: .shoot()


# these functions should be moved into the BulletSpawner class
# but right now just testing them out
func shoot_ring(spokes:int):
	var rot_angle := TAU / spokes
	for _i in range(spokes):
		shoot_single()
		rotate(rot_angle)

# shoot 'count' number of bullets
# with speeds ranging from min_speed_f * bullet_speed to max_speed_f * bullet speed
func shoot_ray(count:int, min_speed_f, max_speed_f):
	var speed_fac_increment:float = (max_speed_f - min_speed_f) / count
	var orig_speed = bullet_speed
	for i in range(1, count+1):
		bullet_speed = orig_speed * i * speed_fac_increment
		shoot_single()
	bullet_speed = orig_speed

func shoot_ray_ring(spokes, count, min_s, max_s):
	var speed_fac_increment:float = (max_s - min_s) / count
	var orig_speed = bullet_speed
	for i in range(1, count+1):
		bullet_speed = orig_speed * i * speed_fac_increment
		shoot_ring(spokes)
	bullet_speed = orig_speed

func shoot_arc(spokes:int, spread:float):
	var original_rot = rotation
	var rot_increment:float = spread/spokes
	rotate(-0.5 * spread)
	for a in range(spokes):
		rotate(rot_increment)
		shoot_single()
	rotation = original_rot
