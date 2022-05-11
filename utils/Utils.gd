class_name Utils

static func clip_vec(vec:Vector2, rect:Rect2)->Vector2:
	return Vector2(
		clamp(vec.x, rect.position.x, rect.end.x),
		clamp(vec.y, rect.position.y, rect.end.y)
	)

static func ass_eq(a, b):
	print("assert %s == %s -> %s" % [a, b, is_equal_approx(a, b)])
	assert(is_equal_approx(a, b))
