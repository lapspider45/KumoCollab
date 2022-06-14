extends BulletSpawner

@export var rot_speed := deg2rad(45.0/2)

func _init():
	add_to_group("autoadvance")

func call_children(method:String):
	for c in children_spawners:
		c.call(method)

#func advance(delta):
#	.advance(delta)
