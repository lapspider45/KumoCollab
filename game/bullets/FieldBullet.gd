extends SimpleBullet

var field : RefCounted
var field_strength = 300.0 # rename to field_influence

func advance(delta):
	velocity += acceleration * delta
	if field is VectorField:
		acceleration = field.sample_vector(position) * field_strength
	else:
		acceleration = Vector2.ZERO
	translate(velocity * delta)
	lifetime -= delta
	
	if lifetime <= 0: queue_free()
