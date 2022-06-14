extends "res://game/bullets/RecursiveBullet.gd"

func spawn_subbullets():
	Kumo.shoot_ray(sub_bullet.instantiate(), position, speed * Vector2.from_angle(Blackboard.player_pos.angle_to_point(position)), ring_spokes, 0.5, 1)
