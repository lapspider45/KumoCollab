extends VectorField

var _min = Vector2(-1.0, -1.0)
var _max = Vector2(1.0, 1.0)
var period = Vector2(TAU, TAU)

func my_sin(x:float, __min:float, __max:float, _period:float, _offset:float):
	var center:float = lerp(__min, __max, 0.5)
	var magnitude := __max - __min
	var freq := TAU / _period
#	var phase := offset / period
	return center + magnitude * sin(freq * x + _offset)

func sample_vector(pos:Vector2)->Vector2:
	var _pos = sample_transform * pos
	return Vector2(
		my_sin(_pos.x, _min.x, _max.x, period.x, offset.x),
		my_sin(_pos.y, _min.y, _max.y, period.y, offset.y)
	) * strength
