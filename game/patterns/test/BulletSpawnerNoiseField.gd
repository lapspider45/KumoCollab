extends BulletSpawner

func shoot():
	shoot_ring(9)

#func _ready():
#	bullet_template.set("field_strength", 160)

func shoot_single():
	var bullet = bullet_template.duplicate(DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	bullet.acceleration = bullet_acceleration
	bullet.set("field", Blackboard.fields.get("noise1", Blackboard.FIELD_EMPTY))
	Kumo.shoot(bullet, global_position, polar2cartesian(bullet_speed, global_rotation) * speedscale)
