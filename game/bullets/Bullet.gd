tool
extends Sprite

export var collision_radius := 1.0
export var radius := 1.0
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2


func _draw():
	if Engine.editor_hint:
		draw_circle(Vector2.ZERO, collision_radius, Color(1, 0, 1, 0.5))

func _custom_process(delta):
	velocity += acceleration * delta
	translate(velocity * delta)
	lifetime -= delta

#const SHAPE = preload("res://default_bullet_shape.tres")
const PLAYER_LAYER = 1

func query_collisions(player:Vector2):
	pass
	var collisions = get_world_2d().direct_space_state.intersect_point(position, 1, [], PLAYER_LAYER, true, false)
