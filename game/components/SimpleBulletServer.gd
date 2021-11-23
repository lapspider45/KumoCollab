# "Server" for processing the "simple" bullet type
# how to use:
# * call process_bullets(delta) once per frame
# * num_batches can be used to calculate slowdown
# * tweak the values to change the behavior
# * don't spawn more than 15000 bullets per second

extends Node2D

signal processed_batch
signal batches_created(count)
signal batches_complete
signal bullet_collided(bullet)

var batch_finished = true
var bullets: Array
var bullet_count: int
var batches: Array #[[bullet, bullet, bullet], [], []]

var batches_remaining: int
var num_batches: int

export var process_batch_size = 1200
#export var max_batches = 2
#export var dynamic_batch_size = false
#export var smooth_slowdown = false
export var max_bullets = 3600

export var player_hitbox_pos : Vector2
export var player_hitbox_radius : float = 1.0

export var bullet_limits: Rect2

var deletion_queue := []


func add_bullet(bullet):
	assert(bullet.has_method("_custom_process"), "simple bullets must have _custom_process method")
	if bullet_count >= max_bullets:
		bullet.queue_free()
		return
	add_child(bullet)

func clear_bullets():
	deletion_queue = get_children()

func process_bullets(delta):
	player_hitbox_pos = Blackboard.player_pos
	
	if batches_remaining == 0:
		create_batches()
	
#	print("processing %05d bullets in batch %d/%d" % [bullet_count, num_batches-batches_remaining, num_batches])
	
	var batch = batches.pop_back()
	if batch:
		var collision = process_single_batch(batch, delta / max(num_batches, 1))
		if collision:
			emit_signal("bullet_collided", collision)
	else:
		print("nothing to process")
	
	batches_remaining = batches.size()
	batch_finished = batches_remaining == 0
	if batch_finished:
		process_deletion_queue() # since no batches are queued, it's safe to delete bullets (again)
		emit_signal("batches_complete")



func process_single_batch(batch:Array, delta:float):
	var collision = null # change to array if multiple collisions are to be detected
	for b in batch:
		if not is_instance_valid(b):
			print("BUG: found a deleted instance in batch")
			continue
		# let bullet move
		b._custom_process(delta)
		
		if not bullet_limits.has_point(b.position):
			deletion_queue.append(b)
			continue
		
		var difference:Vector2 = b.position - player_hitbox_pos
		
		# check collision (first pass)
		var first_pass_box = Rect2(-16, -16, 32, 32) # different sizes may be needed for bullets larger than 16 px radius
		if not first_pass_box.has_point(difference):
			continue
			
		# second pass collision detection
		if difference.length() <= b.radius + player_hitbox_radius:
			collision = b
	emit_signal("processed_batch")
	return collision

func process_deletion_queue():
	for i in range(min(256, deletion_queue.size())):
		var b = deletion_queue.pop_back()
		if is_instance_valid(b):
			b.queue_free()

func create_batches():
	bullets = get_children()
	bullet_count = bullets.size()
	
	# split bullets into batches of size 'process_batch_size'
	for i in range(0, bullet_count, process_batch_size):
		batches.append(bullets.slice(i, i + process_batch_size - 1))
	num_batches = batches.size()
	emit_signal("batches_created", num_batches)
