class_name BulletSpawner
extends Position2D

enum NOTIFICATION {
	CHILD_SPAWNER_ADDED = 10001
}

export var timescale := 1.0

export var bullet_speed := 40.0
export var bullet_lifetime := 10.0
export var bullet_acceleration := Vector2(0,100)
export(float, 0, 1) var bullet_damping := 0.0
export var autoaim := false
# IDEA: allow autoaim strengths between 0-1; 0 means no autoaim, 0.5 means aiming has a 50% influence
# would be useful mostly for smoothly transitioning to/from aiming and fixed/relative
export var aim_offset := 0.0

# TODO: add a way to override properties and enable/disable per difficulty?
# also add some functions to arrange children in various patterns
# and maybe to add additional child spawners

# export var enabled := true
# export var children_enabled := true
export var bullet_type := "basic1"
var B = preload("res://game/bullets/Bullet.tscn")
"""
So nested spawners are pretty neat
each parent spawner needs to:
	(propagate) call advance(delta * timescale) on its child spawners
	keep track of any AnimationPlayer:s

here is an idea:
	each spawner has an advance_children(delta) signal
	reacting to NOTIFICATION_PARENTED and NOTIFICATION_UNPARENTED,
		the child connects/disconnects the parent's signal to/from its own advance() method
	
	also TIL NOTIFICATION_PAUSED and NOTIFICATION_UNPAUSED might be good for actually making the pause system useful, do some testing...
	pausing only has these effects on the nodes that get paused:
		disabling physics (for ALL nodes!)
		disabling _process, _physics_process and _input
		disabling _gui_input on Control nodes
		sending the paused and unpaused notifications as appropriate
	a fine-grained pause system could be done with:
		call_group
		set_process, set_physics_process, set_process_input
		set_internal_process?
		
"""


func _shoot(params:Dictionary={}):
	params.speedscale = params.get("speedscale", timescale)
	if autoaim: aim_at_player()
	for c in children_spawners:
		c._shoot(params)
	shoot(params)

var children_spawners = []

func update_children():
	children_spawners.clear()
	for c in get_children():
		if c.is_in_group("bulletspawner"): children_spawners.append(c)

func shoot(params={}):
	var bullet = BulletServer.instantiate_bullet(bullet_type)
	bullet.set_as_toplevel(true)
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * params.get("speedscale", 1)
	bullet.acceleration = bullet_acceleration
#	add_child(bullet)
	owner.add_bullet2(bullet) # owner needs to be the BulletWorld...

func aim_at_player():
	look_at(get_player_pos())
	rotate(deg2rad(aim_offset))

func get_player_pos(): # TODO
	return Blackboard.player_pos

func _custom_process(delta:float):
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
