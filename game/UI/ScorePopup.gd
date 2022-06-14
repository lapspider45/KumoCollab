extends Label

@export var acceleration := Vector2.ZERO
@export var velocity := Vector2.ZERO
@export var value = 0:
	set(v):
		set_value(v)

func _ready():
	$AnimationPlayer.playback_speed = randf_range(0.7, 1.3)


func popup_at(pos:Vector2):
	# seems to be no direct way to resize label to minimum, this is a hack
	size = Vector2.ZERO
	
	# offset by half of new rect size so that it is centered
	position = pos - 0.5 * size
	# god help you if you use rect_scale for anything
	
	pivot_offset = 0.5 * size


func set_value(num):
	value = num
	text = "%d" % num


func _process(delta):
	velocity += acceleration * delta
	position += velocity * delta
	
#	self.value *= 1.05

func advance(delta):
	pass
