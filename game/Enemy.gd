extends Node2D

export var hp = 10

func take_damage(dmg=1):
	pass
	hp -= dmg
	if hp <= 0:
		die()
	# give player score

func die():
	queue_free()
	pass
	# give player score
	# drop pickups

func advance(delta:float):
	pass


# Enemies can only collide with AreaBullets, i.e. not advanced bullets
func _on_Hitbox_area_entered(area:Area2D):
	pass # Replace with function body.
	area.call("on_hit")
	take_damage()
