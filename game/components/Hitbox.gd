extends Area2D



func physics_query():
	pass
	var shape:Shape2D = $CollisionShape2D.shape
	var shape_transform:Transform2D = $CollisionShape2D.get_viewport_transform()
	var query := Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.collide_with_areas = true
	query.collision_layer = collision_mask
	query.transform = shape_transform
	var collisions = get_world_2d().direct_space_state.intersect_shape(query, 1)
	if collisions.size() >= 1:
		assert (collisions[0] is Dictionary)
		print(collisions)
		return collisions[0]


