extends SimpleBullet

var field : Reference
var field_strength = 300.0

func advance(delta):
	velocity += acceleration * delta
	if field is VectorField:
		acceleration = field.sample_vector(position) * field_strength
	else:
		velocity = Vector2.ZERO
	translate(velocity * delta)
	lifetime -= delta
	
	if lifetime <= 0: queue_free()
