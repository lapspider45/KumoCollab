extends Pattern

var sinefield
@export var field_strength := 1.0:
	set(v):
		if sinefield is VectorField:
			sinefield.strength = v
		field_strength = v
@export var rot_speed := 1.0

func start():
	make_remotetransform2d(Blackboard.boss, $BulletSpawner).position = Vector2(0, 64)
	$BulletSpawner/shoot.play("shoot2")
	$AnimationPlayer.play("vary_strength")

func _ready():
	# add a sine field
	sinefield = preload("res://utils/SineField.gd").new()
	sinefield._min = Vector2(-0.3, -0.3)
	sinefield._max = Vector2(0.3, 0.3)
	sinefield.period = Vector2(60, 260)
	Blackboard.fields["noise1"] = sinefield


func _physics_process(delta):
	Blackboard.boss_pos = $BulletSpawner.global_position
	if sinefield is VectorField:
#		sinefield.offset += Vector2.ONE * delta * 9
#		sinefield.CENTER = Blackboard.boss_pos
		sinefield.sample_transform = sinefield.sample_transform.rotated(delta * 2.4)
	$BulletSpawner.rotate(delta * rot_speed)
