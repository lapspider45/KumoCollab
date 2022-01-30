extends BulletSpawner

func shoot():
	shoot_ring(9)

#func _ready():
#	bullet_template.set("field_strength", 160)

func shoot_single():
	var bullet = bullet_template.duplicate(DUPLICATE_GROUPS + DUPLICATE_SCRIPTS)
	bullet.top_level = true
	bullet.position = global_position
	bullet.velocity = Vector2.RIGHT.rotated(global_rotation) * bullet_speed * speedscale
	bullet.acceleration = bullet_acceleration
	bullet.set("field", Blackboard.fields.get("noise1", Blackboard.FIELD_EMPTY))
	DanmakuServer.add_bullet(bullet)
