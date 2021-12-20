extends SimpleBullet

enum Colors {
	GREEN, CYAN, BLUE, PURPLE, PINK, RED, ORANGE, YELLOW
}

export(Colors) var color = 0 setget set_color

export var rot_velocity = 2.5

func set_color(c:int):
	color = c % hframes
	frame = color

func cycle_color():
	self.color += 1


export var wait_duration := 0.7

func _ready():
	var return_time = wait_duration + 0.05
	
	yield(timer(wait_duration), "completed")
	
	velocity *= 0.1
	acceleration *= 0
	
	yield(timer(0.5), "completed")
	
	velocity *= -10.0
	
	yield(timer(return_time), "completed")
	
	lifetime = 0.0 # kill it once it returns
	
