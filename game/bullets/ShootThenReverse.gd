extends SimpleBullet

enum Colors {
	GREEN, CYAN, BLUE, PURPLE, PINK, RED, ORANGE, YELLOW
}

@export_enum(Colors) var color = 0:
	set(v): set_color(v)

@export var rot_velocity = 2.5

func set_color(c:int):
	color = c % hframes
	frame = color

func cycle_color():
	self.color += 1


@export var wait_duration := 0.7

func _ready():
	var return_time = wait_duration + 0.05
	
	await timer(wait_duration)
	
	velocity *= 0.1
	acceleration *= 0
	
	await timer(0.5)
	
	velocity *= -10.0
	
	await timer(return_time)
	
	lifetime = 0.0 # kill it once it returns
	
