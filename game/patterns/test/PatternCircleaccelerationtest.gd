extends Pattern

func start():
	$AnimationPlayer.play("shoot")
	$AnimationPlayer2.play("default")

func _physics_process(delta):
	$BulletSpawner.the_point = Blackboard.player_pos
