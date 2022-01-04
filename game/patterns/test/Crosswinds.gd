extends Pattern

func start():
	$AnimationPlayer.play("shoot")

func stop():
	$AnimationPlayer.stop()
