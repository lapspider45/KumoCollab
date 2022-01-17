extends SimpleBulletServer

var BULLET_PATH = "res://game/bullets/"

var preloaded_bullets = {
	"basic1": preload("res://game/bullets/SimpleBullet.tscn"),
	"complex1": preload("res://game/bullets/AreaBullet.tscn"),
	"lana_bomb": preload("res://game/bullets/LanaBombSprite.tscn"),
	"lana_sparkle": preload("res://game/bullets/LanaSparkleSprite.tscn"),
	"color1": preload("res://game/bullets/ColorBullet.tscn"),
	"fieldtest": preload("res://game/bullets/FieldBullet.tscn"),
}

func _init():
	autoregister_bullets()

func reparent(to:Node):
	get_parent().remove_child(self)
	to.add_child(self)

func instantiate_bullet(type:String):
	assert(type in preloaded_bullets, "'%s' is not a valid bullet" % type)
	return preloaded_bullets.get(type).instance()

func register_bullet(bullet:PackedScene, _name:String):
	preloaded_bullets[_name] = bullet

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
