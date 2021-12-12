extends Node

var current_server

const BULLETS = {
	"basic1": preload("res://game/bullets/SimpleBullet.tscn"),
	"complex1": preload("res://game/bullets/AreaBullet.tscn"),
	"lana_bomb": preload("res://game/bullets/LanaBombSprite.tscn"),
	"lana_sparkle": preload("res://game/bullets/LanaSparkleSprite.tscn"),
	"color1": preload("res://experiments/ColorBullet.tscn"),
	"fieldtest": preload("res://game/bullets/FieldBullet.tscn"),
}


func instantiate_bullet(type:String):
	assert(type in BULLETS, "'%s' is not a valid bullet" % type)
	return BULLETS.get(type).instance()



func add_bullet(bullet:Node2D):
	if current_server is SimpleBulletServer:
		current_server.add_bullet(bullet)
	else:
		push_error("bullet server not assigned!")
