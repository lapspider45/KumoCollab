class_name Curves
# Helper class for generating and modifying Curve2Ds.
# all functions are static, so you don't need to instance this class
# simply call, for example, `Curves.circle(pos, 16)`

static func make_path2d(curve:Curve2D):
	var path := Path2D.new()
	path.curve = curve
	return path

static func waypoints(points, loop=false):
	var curve := Curve2D.new()
	for p in points:
		curve.add_point(p)
	if loop:
		curve.add_point(points[0])
	return curve

static func circle(origin:Vector2, radius:float):
	# thanks to https://spencermortensen.com/articles/bezier-circle/
	var curve := Curve2D.new()
	for q in [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP, Vector2.RIGHT]:
		var handle:Vector2 = (q * radius * 0.551915).rotated(PI/2)
		curve.add_point(origin + q * radius, -handle, handle)
	return curve

static func polygon(origin:Vector2, radius:float, edges:int):
	assert(edges >= 3)
	var points := PoolVector2Array()
	points.resize(edges)
	for i in range(edges):
		var angle = i/float(edges) * TAU
		points[i] = origin + polar2cartesian(radius, angle)
	return waypoints(points, true)

static func sine(scale = 100, periods = 2):
	# WIP
	# https://stackoverflow.com/a/45451334
	var C = 0.364212
	var curve = Curve2D.new()
	
	# one half cycle
	var h_out = Vector2(0, C) * scale
	var h_in = Vector2(0, -C) * scale
	
	for i in periods * 2:
		curve.add_point(Vector2(i%2, i) * scale, h_in, h_out)
	
	return curve

# converts a Curve2D into a PoolVector2Array of control points, which can be transformed normally, among other things
static func unpack(curve:Curve2D)->PoolVector2Array:
	var result := PoolVector2Array()
	result.resize(curve.get_point_count() * 3)
	for idx in curve.get_point_count():
		var pos = curve.get_point_position(idx)
		# [in, pos, out]
		result[3 * idx] = curve.get_point_in(idx) + pos
		result[3 * idx + 1] = pos
		result[3 * idx + 2] = curve.get_point_out(idx) + pos
	
	return result

# converts a PoolVector2Array of points created by `unpack()` into the corresponding Curve2D.
static func pack(points:PoolVector2Array)->Curve2D:
	var curve := Curve2D.new()
	# warning-ignore:integer_division
	for idx in points.size() / 3:
		var pos = points[3 * idx + 1]
		curve.add_point(
			pos,
			points[3 * idx] - pos,
			points[3 * idx + 2] - pos
		)
	return curve

static func transform(curve:Curve2D, trans:Transform2D)->Curve2D:
	return pack(trans.xform(unpack(curve)))

static func merge(c1:Curve2D, c2:Curve2D, loop:=false)->Curve2D:
	var points = unpack(c1)
	points.append_array(unpack(c2))
	if loop:
		points.append(points[0])
		points.append(points[1])
		points.append(points[2])
	return pack(points)

static func print_path(curve):
	for p in curve.get_point_count():
		print("pos: %s, in: %s, out: %s" % [curve.get_point_position(p), curve.get_point_in(p), curve.get_point_out(p)])
