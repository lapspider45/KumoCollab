extends BulletSpawner

enum modes {
	SINGLE,
	RING,
	RAY,
	RAY_RING,
	ARC
}

@export_enum(modes) var mode := 0



@export var spokes:int = 9
@export var ray_count:int = 5
@export var rot_velocity := deg2rad(0.0)
@export var ray_min_speedf = 0.2
@export var ray_max_speedf = 1.0
@export var arc_spread_rad = deg2rad(90)
func _init():
	add_to_group("autoadvance")

func advance(delta):
	rotate(delta * rot_velocity)
	super(delta)

func shoot():
	if disabled: return
	if autoaim:
		aim_at_player()
	match mode:
		modes.SINGLE:
			shoot_single()
		modes.RING:
			shoot_ring(spokes)
		modes.RAY:
			shoot_ray(ray_count, ray_min_speedf, ray_max_speedf)
		modes.RAY_RING:
			shoot_ray_ring(spokes, ray_count, ray_min_speedf, ray_max_speedf)
		modes.ARC:
			var arc_spokes = 5
			shoot_arc(spokes, arc_spread_rad)

