extends Node


const BULLETS = {
	"basic1": preload("res://game/bullets/Bullet.tscn"),
	"complex1": preload("res://game/bullets/AreaBullet.tscn"),
}


func instantiate_bullet(type:String):
	assert(type in BULLETS, "'%s' is not a valid bullet" % type)
	return BULLETS.get(type).instance()



