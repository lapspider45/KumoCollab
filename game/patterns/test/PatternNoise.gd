extends Pattern

var noisefield

func _ready():
	# add a noise field
	noisefield = preload("res://utils/NoiseField.gd").new()
	noisefield.noise_x.seed = 3587
	noisefield.noise_y.seed = 5678
	Blackboard.fields["noise1"] = noisefield
	
	noisefield.noise_x.period = 130
	noisefield.noise_y.period = 130
	
	set_physics_process(false)

func start():
	set_physics_process(true)
	$BulletSpawner/shoot.play("shoot")


func _physics_process(delta):
	Blackboard.boss_pos = $BulletSpawner.global_position
	if noisefield is VectorField:
		noisefield.offset += Vector2.ONE * delta * 9
		noisefield.CENTER = Blackboard.boss_pos
