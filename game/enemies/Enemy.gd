class_name Enemy
extends Node2D

signal died

export var hp := 10.0
export var invincible := false

func take_damage(dmg=1):
	if invincible: return
	hp -= dmg
	if hp <= 0:
		die()
	# give player score

func die():
	SFX.play("boom1")
	queue_free()
	emit_signal("died")
	# give player score
	# drop pickups

func _on_Hitbox_took_damage(value):
	if invincible: return
	take_damage(value)


### MOVEMENT

export var move_speed := 120.0 # maximum movement speed
export var acceleration := 360.0
export(float, 0, 1) var damping := 0.2
var velocity := Vector2()

#export var acceleration

enum MOVE {
	STATIC, TOWARDS_POINT, AWAY_FROM_POINT, DIRECTION, CHASE_PLAYER, CHASE_NODE, INERTIA, INERTIA_BOUNCE
}
export(MOVE) var movement_mode := MOVE.STATIC
export var enable_acceleration := false
export var target_is_player := false # whether to automatically set target_pos to player_pos on each frame

export var target_point : Vector2
export var movement_direction := Vector2.DOWN
export var target_path : NodePath

func advance(delta:float):
	movement(delta)

func movement(delta:float):
	if target_is_player:
		target_point = Blackboard.player_pos
	match movement_mode:
		MOVE.STATIC:
			pass
		MOVE.TOWARDS_POINT:
			move_towards_point(target_point, delta)
		MOVE.AWAY_FROM_POINT:
			move_direction(target_point.direction_to(position), delta)
		MOVE.DIRECTION:
			move_direction(movement_direction.normalized(), delta)
		MOVE.CHASE_PLAYER:
			move_towards_point(Blackboard.player_pos, delta)
		MOVE.CHASE_NODE:
			move_towards_point(get_node_pos(get_node_or_null(target_path)), delta)
		_:
			assert(false, "movement mode %s is not implemented yet" % [MOVE.keys()[movement_mode]])
	
	velocity_damp(delta)

func move_direction(vec:Vector2, delta:float):
	if enable_acceleration:
		velocity = (velocity + vec * acceleration).clamped(move_speed)
		translate(velocity * delta)
	else:
		translate(vec * move_speed * delta)

func move_towards_point(point:Vector2, delta:float):
	move_direction(position.direction_to(point), delta)

func get_node_pos(node:Node2D)->Vector2:
	if is_instance_valid(node): return node.position
	else:
		breakpoint
		return Vector2( 240, 320 )

func velocity_damp(delta):
	velocity = velocity.linear_interpolate(Vector2.ZERO, damping * delta)
