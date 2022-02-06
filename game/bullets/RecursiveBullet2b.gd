extends "res://game/bullets/RecursiveBullet.gd"

func spawn_subbullets():
	Kumo.shoot_ray(sub_bullet.instance(), position, polar2cartesian(speed, Blackboard.player_pos.angle_to_point(position)), ring_spokes, 0.5, 1)
