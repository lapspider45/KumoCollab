extends "res://game/player/Player.gd"

func _ready():
	._ready()
	$BulletSpawner4.B = preload("res://game/bullets/AreaBullet.tscn")
	
