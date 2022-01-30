extends SimpleBullet

enum Colors {
	GREEN, CYAN, BLUE, PURPLE, PINK, RED, ORANGE, YELLOW
}

@export_enum(Colors) var color = 0:
	set(v): set_color(v)

@export var rot_velocity = 2.5

func set_color(c:int):
	color = c
	frame = color % hframes


func advance(delta):
	rotate(rot_velocity * delta)
	super(delta)
