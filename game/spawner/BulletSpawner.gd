class_name BulletSpawner
extends Position2D

enum NOTIFICATION {
	CHILD_SPAWNER_ADDED = 10001
}

var children_spawners = []

export var timescale := 1.0
export var speedscale := 1.0
export var bullet_speed := 40.0
export var bullet_lifetime := 10.0
export var bullet_acceleration := Vector2(0,100)
export(float, 0, 1) var bullet_damping := 0.0
export var autoaim := false
# IDEA: allow autoaim strengths between 0-1; 0 means no autoaim, 0.5 means aiming has a 50% influence
# would be useful mostly for smoothly transitioning to/from aiming and fixed/relative
export var aim_offset := 0.0

export var disabled := false
export var children_disabled := false
# TODO: add a way to override properties and enable/disable per difficulty?
# also add some functions to arrange children in various patterns
# and maybe to duplicate child spawners

export var bullet_type := "basic1" setget set_bullet_type
var bullet_template: Node
var bullet_params := {}

func _ready():
	set_bullet_type(bullet_type)

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
	var bullet = bullet_template.duplicate(DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * speedscale
	bullet.acceleration = bullet_acceleration
	DanmakuServer.add_bullet(bullet)

func aim_at_player():
	look_at(get_player_pos())
	rotate(deg2rad(aim_offset))

func get_player_pos(): # TODO
	return Blackboard.player_pos

func advance(delta:float):
	var anim = get_node_or_null("AnimationPlayer")
	if anim is AnimationPlayer:
		anim.advance(delta * timescale)
	else:
		print("animation palyer not found")

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

func set_bullet_type(t:String):
	bullet_type = t
	bullet_template = DanmakuServer.instantiate_bullet(bullet_type)

func set_bullet_collision(c:int):
	if bullet_template is Area2D:
		bullet_template.collision_layer = c
