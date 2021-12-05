extends Area2D

export var speed = 600
export var acceleration = 1200
var velocity := Vector2.ZERO
var direction := Vector2.DOWN


func _physics_process(delta):
	if Blackboard.player_pos.distance_to(global_position) <= Blackboard.player_pickup_radius or Blackboard.player_pos.y <= Blackboard.player_pickup_line:
		_homing(delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta / 16)
	velocity += Vector2(0,speed) * delta / 4
	velocity = velocity.clamped(speed)
	translate(velocity * delta)


func _homing(delta):
	var difference = Blackboard.player_pos - global_position
	direction = (difference).normalized() * 4
	velocity = velocity + direction * acceleration * delta


func _on_Item_area_entered(area):
	print("Power Up")
	queue_free()
