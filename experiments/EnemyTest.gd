extends Node2D

func _ready():
	DanmakuServer.bullet_hit.connect(bullet_hit_sfx)

func bullet_hit_sfx(bullet):
	
	var vrect := get_viewport_rect()
	var pan_position := 2 * (inverse_lerp(vrect.position.x, vrect.end.x, bullet.position.x) - 0.5)
	
	SFX.play("hit", pan_position)
