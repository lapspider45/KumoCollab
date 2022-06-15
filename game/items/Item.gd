extends Area2D

@export var speed = 600
@export var acceleration = 1200
var velocity := Vector2.ZERO
var direction := Vector2.DOWN
var is_player_found := false


func _physics_process(delta):
	if is_player_found:
		_homing(delta)
	elif (Blackboard.player_pos.distance_to(global_position) <= Blackboard.player_pickup_radius
			or 	Blackboard.player_pos.y <= Blackboard.player_pickup_line):
				is_player_found = true
				_homing(delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta / 16)
	velocity += Vector2(0,speed) * delta / 4
	velocity = velocity.limit_length(speed)
	translate(velocity * delta)


func _homing(delta):
	var difference = Blackboard.player_pos - global_position
	direction = difference.normalized() * 4
	velocity = direction * acceleration * delta * speed


func _on_Item_area_entered(_area):
	
	queue_free()
