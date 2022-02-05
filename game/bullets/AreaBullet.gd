extends Area2D

export var radius = -10000
export var velocity:Vector2
export var lifetime := 10.0
export var acceleration:Vector2
export var delete_outside_screen := true
export var damage := 1.0 # how much damage this bullet deals, only affects bosses since player always gets oneshot

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
	Kumo.emit_signal("bullet_hit", self)
	queue_free()

# called when the bullet instance is shot.
func _on_shot():
	pass
