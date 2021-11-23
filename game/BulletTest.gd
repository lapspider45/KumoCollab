extends Node2D


func _ready():
	var view_size:Vector2 = get_viewport().size
#	Blackboard.init_screen_points(0, view_size.x, 0, view_size.y)
	var playfield_size := Vector2(480, 640)
#	var playfield_origin := (view_size - playfield_size) * 0.5
	var screen_rect := Rect2(Vector2.ZERO, playfield_size)
	Blackboard.init_screen_rect(screen_rect)
	bullet_limits = Blackboard.get_bullet_limits()
	
#	$BulletSpawner2/AnimationPlayer.play("asd")

var t = 0.3



func add_bullet(bullet:Node2D):
	if bullet_count >= MAX_BULLETS_TOTAL:
		bullet.queue_free()
	bullet.add_to_group("bullets")

var deletion_queue = []
var bullet_queue = []
const MAX_BULLETS_PER_FRAME = 2048
const MAX_BULLETS_TOTAL = 4096

var bullet_limits: Rect2
var bullet_count = 0
var player_radius = 1.0
var player_lives = 100

func _process(delta):
	# empty deletion queue
	if not deletion_queue.empty():
		for i in range(384):
			var b = deletion_queue.pop_back()
			if b and is_instance_valid(b):
				b.queue_free()
#			else: break
	
	var collision = null
	var player_invincible = $Player.invincible
	var player_pos = $Player.global_position
	var player_radius = 1
	
	# update up to MAX_BULLETS_PER_FRAME of the bullets
	var bullet_fillup = clamp(float(bullet_queue.size())/MAX_BULLETS_PER_FRAME, 0, 1)
	# smooth out the intentional slowdown
#	if bullet_queue.size() < MAX_BULLETS_PER_FRAME:
#		delta *= bullet_slowdown.interpolate_baked(bullet_fillup)
	
	var queue = bullet_queue.slice(0,MAX_BULLETS_PER_FRAME)
	bullet_queue = bullet_queue.slice(MAX_BULLETS_PER_FRAME, MAX_BULLETS_TOTAL)
	
	for b in queue:
		if not is_instance_valid(b):
			continue
		b._custom_process(delta)
		if not bullet_limits.has_point(b.position):
			deletion_queue.append(b)
	
	if bullet_queue.size() == 0:
		# intentional slowdown unless queue was emptied
		
		# queue was exhausted, so next frame we can begin processing a new batch
		bullet_queue = get_tree().get_nodes_in_group("bullets")
		bullet_count = bullet_queue.size()
		# since queue was exhausted_ run collision for all bullets
		collision = check_collisions()
		
		$Player._custom_process(delta)
		get_tree().call_group("TickedAnimationPlayer", "advance", delta)
	
#	collision = check_collisions()
	if collision:
#		collision.queue_free()
#		$Bullets.hide()
		player_hurt()
	
	t -= delta
	while t <= 0:
		t += 0.3
#		$BulletSpawner2._shoot()



func check_collisions():
	var player_pos = $Player.global_position
	
	var first_pass_box = Rect2(-16, -16, 32, 32)
	first_pass_box.position += player_pos
	var all_bullets = get_tree().get_nodes_in_group("bullets")
	bullet_count = all_bullets.size()
	if $Player.invincible:
		return
	for b in all_bullets:
		if not first_pass_box.has_point(b.position):
			# thanks reddit for this optimization
			# which raises the headroom by ~1000 bullets
			continue
		
		
		var radius = b.collision_radius + player_radius
		if b.position.distance_to(player_pos) <= radius:
			return b

#func check_collisions2():
##	var collisions = get_world_2d().direct_space_state.intersect_point(b.position, 1, [], PLAYER_LAYER, true, false)
#	var query := Physics2DShapeQueryParameters.new()
#	query.set_shape(SHAPE)
#	query.collide_with_bodies = true
#	query.collision_layer = PLAYER_LAYER
#	query.transform = b.get_transform()
#	var collisions = get_world_2d().direct_space_state.intersect_shape(query, 1)
#	if collisions.size() == 1:
#		assert (collisions[0] is Dictionary)
#		print(collisions)
#		return b

func player_hurt():
	player_lives -= 1
	$Player.hurt()
	deletion_queue = get_tree().get_nodes_in_group("bullets")
