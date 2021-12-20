extends Pattern

func start():
	$Pattern/AnimationPlayer.play("asd")
	$Pattern/AnimationPlayer2.play("asda")

func reset():
	$Pattern/AnimationPlayer.seek(0)
	$Pattern/AnimationPlayer2.seek(0)

func stop():
	$Pattern/AnimationPlayer.stop()
	$Pattern/AnimationPlayer2.stop()
