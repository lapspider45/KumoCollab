extends BulletSpawner


export var speed := 120
export var acceleration := -20
onready var inward_acceleration := Vector2(acceleration, 0)
var total_vector := Vector2(0, 100)
onready var has_trail := true
onready var trail_group := get_tree().get_nodes_in_group("trails")
export var radius := 50
var previous_length := 50.0
var is_grow := true
var index_in_group := 0


func _ready():
	reset()


func reset():
	var orbit_group := get_tree().get_nodes_in_group("orbitoption")
	var option_amount = orbit_group.size()
	index_in_group = orbit_group.find(self)
	var rotation_angle = (2 * PI / option_amount) * index_in_group
	position = Vector2(0, radius).rotated(rotation_angle)
	if option_amount == 2:
		rotation_angle = 0
	total_vector = Vector2(speed, 0).rotated(rotation_angle)


func _physics_process(delta):
	total_vector += inward_acceleration.rotated(position.angle_to_point(Vector2.ZERO))
	global_position += total_vector * delta
	$OrbitOptionSprite.rotate(2 * PI * delta)
	if is_grow and previous_length > position.length():
		is_grow = false
		$OrbitOptionSprite.z_index *= -1
	elif not is_grow and previous_length < position.length():
		is_grow = true
	previous_length = position.length()
	if has_trail:
		trail_group[index_in_group].set_new_position(position, $OrbitOptionSprite.z_index)
