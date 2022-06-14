class_name BulletSpawner
extends Position2D

signal spawned(bullet_ref)

enum NOTIFICATION {
	CHILD_SPAWNER_ADDED = 10001
}

var children_spawners = []
var bullet_group_id := ""

# Godot 4 compatibility fix
var rotation_degrees:float = rad2deg(rotation):
	set(v):
		rotation_degrees = v
		rotation = deg2rad(v)

@export var timescale := 1.0
@export var speedscale := 1.0
@export var bullet_speed := 40.0
@export var bullet_lifetime := 10.0
@export var bullet_acceleration := Vector2(0,100)
@export_range(0.0, 1.0) var bullet_damping := 0.0
@export var autoaim := false
# IDEA: allow autoaim strengths between 0-1; 0 means no autoaim, 0.5 means aiming has a 50% influence
# would be useful mostly for smoothly transitioning to/from aiming and fixed/relative
@export var aim_offset := 0.0

@export var disabled := false
@export var children_disabled := false
# TODO: add a way to override properties and enable/disable per difficulty?
# also add some functions to arrange children in various patterns
# and maybe to duplicate child spawners

@export var follow_node:NodePath
@export var enable_follow_node := false

@export var bullet_type := "basic1":
	set(v):
		bullet_type = v
		setup_bullet_template()
var bullet_template: Node
var bullet_params := {}

func _init():
	bullet_group_id = generate_unique_group_id()

func _ready():
	setup_bullet_template()

func _shoot(params:Dictionary={}):
	bullet_params.speedscale = params.get("speedscale", speedscale)
	for k in params:
		set_param(k, params[k])
	if autoaim: aim_at_player()
	
	if not children_disabled:
		for c in children_spawners:
			c._shoot(params)
	if not disabled:
		shoot()



func update_children():
	children_spawners.clear()
	for c in get_children():
		if c.is_in_group("bulletspawner"):
			children_spawners.append(c)

func set_param(k, v):
	var t = bullet_template
	match k:
		"speedscale":
			bullet_params.speedscale = v
			speedscale = v
	bullet_params[k] = v

func shoot():
	shoot_single()

func shoot_single():
	var bullet = bullet_template
	bullet.acceleration = bullet_acceleration
	Kumo.shoot(bullet, global_position, bullet_speed * Vector2.from_angle(global_rotation) * speedscale)
	emit_signal("spawned", bullet)

func shoot_velocity(velocity:Vector2):
	var bullet = bullet_template
	bullet.acceleration = bullet_acceleration
	bullet.lifetime = bullet_lifetime
	Kumo.shoot(bullet, global_position, velocity * speedscale)
	emit_signal("spawned", bullet)

func shoot_ring(num_spokes:int):
	var rot_angle := TAU / num_spokes
	for i in range(num_spokes):
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
		bullet_speed = orig_speed * (min_s + i * speed_fac_increment)
		shoot_ring(spokes)
	bullet_speed = orig_speed

func shoot_arc(spokes:int, spread:float):
	var original_rot = rotation
	var rot_increment:float = spread/spokes
	rotate(-0.5 * (spread + rot_increment))
	for a in range(spokes):
		rotate(rot_increment)
		shoot_single()
	rotation = original_rot

func aim_at_player():
	look_at(get_player_pos())
#	rotate(deg2rad(aim_offset))

func accelerate_towards_point(point:Vector2, magnitude:float):
	bullet_acceleration = global_position.direction_to(point) * magnitude

func get_player_pos(): # TODO
	return Blackboard.player_pos

func advance(delta:float):
	if enable_follow_node:
		var node = get_node_or_null(follow_node) as Node2D
		if node:
			global_position = node.global_position

func _notification(what):
	match what:
		NOTIFICATION_PARENTED:
			pass # tell parent that i'm their new child
#			print("%s parented to %s" % [name, get_parent()])
			get_parent().notification(NOTIFICATION.CHILD_SPAWNER_ADDED)
		NOTIFICATION_UNPARENTED:
			pass # say goodbye to parent
		NOTIFICATION.CHILD_SPAWNER_ADDED:
#			print("%s got a new child spawner" % [self])
			update_children()
		_:
			pass

func set_bullet_collision(c:int):
	if bullet_template is Area2D:
		bullet_template.collision_layer = c

func set_player(v=true): # belongs to player
	set_bullet_collision(8 if v else 16)

func setup_bullet_template():
	if is_instance_valid(bullet_template):
		bullet_template.queue_free()
	bullet_template = Kumo.instantiate_bullet(bullet_type)
	bullet_template.add_to_group(bullet_group_id)

func generate_unique_group_id():
	return "bullet@%s" % get_instance_id()

func get_spawned_bullets():
	return get_tree().get_nodes_in_group(bullet_group_id)
