extends VectorField

var noise_x := OpenSimplexNoise.new()
var noise_y := OpenSimplexNoise.new()

func _init():
	for noise in [noise_x, noise_y]: if noise is OpenSimplexNoise:
		noise.octaves = 1
		noise.period = 150


func sample_vector(pos:Vector2)->Vector2:
	var t_pos = pos + offset
	return Vector2(
		noise_x.get_noise_2dv(t_pos),
		noise_y.get_noise_2dv(t_pos)
	) + away_from_center(pos, 100) * 10
#	return away_from_center(pos, 100) * 30

