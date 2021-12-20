extends AnimationPlayer

func _init():
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	add_to_group("TickedAnimationPlayer")
