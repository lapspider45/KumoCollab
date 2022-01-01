extends Node

var current_server:Node

var BULLET_PATH = "res://game/bullets/"

var bullets = {
	"basic1": preload("res://game/bullets/SimpleBullet.tscn"),
	"complex1": preload("res://game/bullets/AreaBullet.tscn"),
	"lana_bomb": preload("res://game/bullets/LanaBombSprite.tscn"),
	"lana_sparkle": preload("res://game/bullets/LanaSparkleSprite.tscn"),
	"color1": preload("res://game/bullets/ColorBullet.tscn"),
	"fieldtest": preload("res://game/bullets/FieldBullet.tscn"),
}

func _init():
	autoregister_bullets()


func instantiate_bullet(type:String):
	assert(type in bullets, "'%s' is not a valid bullet" % type)
	return bullets.get(type).instance()


	
func add_bullet(bullet:Node2D):
	if current_server is SimpleBulletServer:
		current_server.add_bullet(bullet)
	else:
		push_error("bullet server not assigned!")

func register_bullet(bullet:PackedScene, _name:String):
	bullets[_name] = bullet

func autoregister_bullets():
	var dir := DirUtils.new()
	var err := dir.open(BULLET_PATH)
	if err != OK:
		breakpoint
		return
	for entry in dir.ls():
		if entry.type == DirUtils.TYPE_FILE and entry.name.ends_with(".tscn"):
			var bullet_name = entry.name.trim_suffix(".tscn")
			register_bullet(load(entry.path), bullet_name)
