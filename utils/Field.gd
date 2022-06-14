class_name VectorField
extends RefCounted

@export var offset := Vector2.ZERO
@export var strength := 1.0
@export var sample_transform := Transform2D.IDENTITY

func sample_scalar(pos:Vector2)->float:
	return 0.0

func sample_vector(pos:Vector2)->Vector2:
	return Vector2()

func sample_bool(pos:Vector2)->bool:
	return false

var CENTER = Vector2(480,640) * 0.5

func away_from_center(pos:Vector2, tresh=0.1):
	return CENTER.direction_to(pos) / max(CENTER.distance_to(pos), tresh)


func attraction_to_point(point, radius, power):
	pass

func repulsion_from_point(point, radius, power):
	pass

func remove_influence_around_point(point, radius, power):
	pass
