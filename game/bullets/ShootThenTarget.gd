extends SimpleBullet

export var wait_duration := 0.3

func _ready():
	yield(timer(wait_duration), "completed")
	
	velocity *= 0.1
	acceleration *= 0
	
	yield(timer(0.5), "completed")
	
	velocity = position.direction_to(Blackboard.player_pos) * 200
