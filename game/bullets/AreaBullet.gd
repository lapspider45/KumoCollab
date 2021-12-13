extends Area2D

export var radius = -10000
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2

#const SHAPE = preload("res://default_bullet_shape.tres")
const PLAYER_LAYER = 1

func query_collisions(player:Vector2):
	pass
	var collisions = get_world_2d().direct_space_state.intersect_point(position, 1, [], PLAYER_LAYER, true, false)

func advance(delta):
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta

func on_hit():
	queue_free()
