extends Pattern

@export var bullet_speed := 480
@export var bullet_wait_time := 1.5

@export var bullet_scene: PackedScene
@export var subbullet_scene: PackedScene

@export_range(0, 360, 0.5) var angle := 90.0

func start():
	print("started Lana Recursive")
	$AnimationPlayer.play("pattern")
	if is_instance_valid(Blackboard.boss):
		make_remotetransform2d(Blackboard.boss)


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.wait_time = bullet_wait_time
	bullet.sub_bullet = subbullet_scene
	Kumo.shoot_at(bullet, global_position, Blackboard.player_pos, bullet_speed)
