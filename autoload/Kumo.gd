extends SimpleBulletServer

# warning-ignore:unused_signal
signal bullet_hit(bullet)

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



### And now, some utility functions for shooting bullets.


# Shoot the specified bullet from the given position, with the given velocity
# Acceleration or other properties will not be set by this function.
# example usage: Kumo.shoot(bullet_template.duplicate(), global_position, polar2cartesian(global_rotation, bullet_speed))
func shoot(bullet:Node, from_pos:Vector2, velocity:Vector2):
	bullet.set_as_toplevel(true) # TODO: this might be unnecessary
	bullet.position = from_pos
	bullet.velocity = velocity
	add_bullet(bullet)
	bullet.call("_on_shot")

func shoot_at(bullet:Node, from_pos:Vector2, target_pos:Vector2, speed:float):
	shoot(bullet, from_pos, (target_pos-from_pos).clamped(1) * speed)
