extends SimpleBullet

enum Colors {
	GREEN, CYAN, BLUE, PURPLE, PINK, RED, ORANGE, YELLOW
}

@export var color:Colors = Colors.GREEN:
	set(c):
		color = c
		frame = color % hframes

@export var rot_velocity = 2.5



func advance(delta):
	rotate(rot_velocity * delta)
	super(delta)
