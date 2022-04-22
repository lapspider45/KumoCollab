extends Node2D

func _ready():
#	var trans = Transform2D.IDENTITY.scaled(Vector2(3,1)).rotated(-TAU/8)
#	$Path2D.curve = Curves.transform(Curves.sine(50, 3), trans)
#	print(Curves.unpack($Path2D.curve))
#	$Path2D.curve = Curves.waypoints([
#		Vector2(100,100),
#		Vector2(100,200),
#		Vector2(200,100),
#		Vector2(200,200)
#	], true)
	$Path2D.curve = Curves.circle(Vector2(200,200), 60)
#	$Path2D.curve = Curves.merge(Curves.circle(Vector2(200,200), 60), Curves.polygon(Vector2(400,400), 60, 6), true)
	Curves.print_path($Path2D.curve)
