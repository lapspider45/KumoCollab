extends SimpleBullet

enum Colors {
	GREEN, CYAN, BLUE, PURPLE, PINK, RED, ORANGE, YELLOW
}

export(Colors) var color = 0 setget set_color

export var rot_velocity = 2.5

func set_color(c:int):
	color = c
	frame = color % hframes


func advance(delta):
	rotate(rot_velocity * delta)
	.advance(delta)
