extends Pattern

func start():
	$shoot.play("shoot2 - hard")

func reset():
	$shoot.seek(0, false)
