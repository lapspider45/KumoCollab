extends Pattern

func start():
	$BulletSpawner/AnimationPlayer.play("shoot")
	
#	$AnimationPlayer.play("pattern")

func _process(delta):
	$BulletSpawner.rotate(delta / 7)
