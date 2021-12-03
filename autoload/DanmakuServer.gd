extends Node

var current_server

const BULLETS = {
	"basic1": preload("res://game/bullets/SimpleBullet.tscn"),
	"complex1": preload("res://game/bullets/AreaBullet.tscn"),
}


func instantiate_bullet(type:String):
	assert(type in BULLETS, "'%s' is not a valid bullet" % type)
	return BULLETS.get(type).instance()



func add_bullet(bullet:Node2D):
	if current_server is SimpleBulletServer:
		current_server.add_bullet(bullet)
	else:
		push_error("bullet server not assigned!")
