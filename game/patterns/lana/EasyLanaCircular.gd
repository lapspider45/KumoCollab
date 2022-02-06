extends Pattern

func start():
	make_remotetransform2d(Blackboard.boss, $EasyLanaCircularPattern)
	
	$EasyLanaCircularPattern/AnimationPlayer.play("asd")

func stop():
	$EasyLanaCircularPattern/AnimationPlayer.stop()
	Kumo.clear_bullets()
