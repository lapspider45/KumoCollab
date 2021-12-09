extends Pattern


func _physics_process(delta):
	$BulletSpawner.the_point = $thepoint.position
