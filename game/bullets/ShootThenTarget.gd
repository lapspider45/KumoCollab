extends SimpleBullet

@export var wait_duration := 0.3

func _ready():
	await timer(wait_duration)
	
	velocity *= 0.1
	acceleration *= 0
	
	await timer(0.5)
	
	velocity = position.direction_to(Blackboard.player_pos) * 200
