extends SimpleBulletServer

# warning-ignore:unused_signal
signal bullet_hit(bullet)

var BULLET_DUP_FLAGS = DUPLICATE_GROUPS | DUPLICATE_SCRIPTS

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
# example usage: `Kumo.shoot(bullet_template, global_position, polar2cartesian(global_rotation, bullet_speed))`
func shoot(bullet_template:Node, from_pos:Vector2, velocity:Vector2):
	var bullet = bullet_template.duplicate(BULLET_DUP_FLAGS)
#	bullet.set_as_toplevel(true) # TODO: this might be unnecessary
	bullet.position = from_pos
	bullet.velocity = velocity
	add_bullet(bullet)
	bullet.call("_on_shot")

func shoot_at(bullet:Node, from_pos:Vector2, target_pos:Vector2, speed:float):
	shoot(bullet, from_pos, (target_pos-from_pos).clamped(1) * speed)

func shoot_ring(bullet:Node, from_pos:Vector2, velocity:Vector2, spokes:int):
	var rot_angle := TAU / spokes
	for i in spokes-1:
		shoot(bullet, from_pos, velocity.rotated((i+1) * rot_angle))
	shoot(bullet, from_pos, velocity)

# shoot 'count' number of bullets
# with speeds ranging from min_speed_f * bullet_speed to max_speed_f * bullet speed
func shoot_ray(bullet:Node, from_pos:Vector2, velocity:Vector2, \
		count:int, min_speed_f:float, max_speed_f:float):
	if count < 2:
		shoot(bullet, from_pos, velocity)
		return
	var speed_fac_increment:float = (max_speed_f - min_speed_f) / (count-1)
	for i in count-1:
		shoot(bullet, from_pos, velocity * (min_speed_f + i * speed_fac_increment))
	shoot(bullet, from_pos, velocity * max_speed_f)

# shoot a bullet from each point in `from_points` with its corresponding given velocity
# man, lambda support in gd4 would be so sweet
# TODO: test if this actually works
func shoot_points_with_velocities(bullet:Node, from_points:PoolVector2Array, velocities:PoolVector2Array):
	assert(from_points.size() == velocities.size())
	for idx in from_points.size():
		shoot(bullet, from_points[idx], velocities[idx])

# shoots out a cloud of points in the pattern given by `points`
# if `origin` is omitted or Vector2.INF, points will be shot relative from `from_pos`
# if `origin` is Vector2(0,0) the points will be treated as individual velocities.
# TODO: also test if this actually works
func shoot_points(bullet:Node, from_pos:Vector2, points:PoolVector2Array, origin:=Vector2.INF):
	if origin == Vector2.INF:
		origin = from_pos
	for idx in points.size():
		shoot(bullet, from_pos, points[idx]-origin)
