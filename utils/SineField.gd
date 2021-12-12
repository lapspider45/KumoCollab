extends VectorField

var _min = Vector2(-1.0, -1.0)
var _max = Vector2(1.0, 1.0)
var period = Vector2(TAU, TAU)

func my_sin(x:float, _min:float, _max:float, period:float, offset:float):
	var center:float = lerp(_min, _max, 0.5)
	var magnitude := _max - _min
	var freq := TAU / period
#	var phase := offset / period
	return center + magnitude * sin(freq * x + offset)

func sample_vector(pos:Vector2)->Vector2:
	var _pos = sample_transform.xform(pos)
	return Vector2(
		my_sin(_pos.x, _min.x, _max.x, period.x, offset.x),
		my_sin(_pos.y, _min.y, _max.y, period.y, offset.y)
	) * strength
