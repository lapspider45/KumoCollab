# "Server" for processing the "simple" bullet type
# in other words, most bullets should be handled this way
# how to use:
# * call process_bullets(delta) once per frame
# * num_batches can be used to calculate slowdown
# * tweak the values to change the behavior
# * don't spawn more than 15000 bullets per second
class_name SimpleBulletServer
extends Node2D

signal processed_batch
signal batches_created(count)
signal batches_complete
signal bullet_collided(bullet)

const COLLISION_FIRST_PASS = Rect2(-16, -16, 32, 32) # different sizes may be needed for bullets larger than 16 px radius

var batch_finished = true
var bullets: Array
var bullet_count: int
var batches: Array #[[bullet, bullet, bullet], [], []]

var batches_remaining: int
var num_batches: int

export var process_batch_size = 1200
export var max_batches = 3
#export var dynamic_batch_size = false
#export var smooth_slowdown = false
export var max_bullets = 3600

export var player_hitbox_pos : Vector2
export var player_hitbox_radius : float = 1.0

export var bullet_limits: Rect2

var deletion_queue := []

func _ready():
	DanmakuServer.current_server = self

func add_bullet(bullet):
	assert(bullet.has_method("advance"), "simple bullets must have advance method")
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
		var collision = process_single_batch(batch, delta * get_slowdown())
		if collision:
			emit_signal("bullet_collided", collision)
	else:
		pass
#		print("nothing to process")
	
	batches_remaining = batches.size()
	batch_finished = (batches_remaining == 0)
	if batch_finished:
		emit_signal("batches_complete")
	process_deletion_queue()


# it might be possible to process bullets in a thread
# to remove slowdown completely

func process_single_batch(batch:Array, delta:float):
	var collision = null # change to array if multiple collisions are to be detected
	for b in batch:
		if not is_instance_valid(b):
			push_warning("BUG: found a deleted instance in batch")
			continue
		# let bullet move
		b.advance(delta)
		
		# delete bullets outside the screen
		if not bullet_limits.has_point(b.position):
			deletion_queue.append(b)
			continue
		
		# check collision (first pass, simple and performant)
		var difference:Vector2 = b.position - player_hitbox_pos
		if not COLLISION_FIRST_PASS.has_point(difference):
			continue
			
		# second pass collision detection
		if difference.length() <= b.radius + player_hitbox_radius:
			collision = b
	emit_signal("processed_batch")
	return collision

func process_deletion_queue():
	for _i in range(min(256, deletion_queue.size())):
		var b = deletion_queue.pop_back()
		if is_instance_valid(b):
			b.queue_free()

func create_batches():
	bullets = get_children()
	bullet_count = bullets.size()
	
	if bullet_count == 0:
		return
	
	# split bullets evenly into the minimum number of batches smaller than 'process_batch_size'
	var batches_needed = min(ceil(float(bullet_count) / process_batch_size), max_batches)
	var batch_size = ceil(float(bullet_count) / batches_needed)
	for i in range(0, bullet_count, batch_size):
		batches.append(bullets.slice(i, i + batch_size - 1))
	num_batches = batches.size()
	assert(num_batches == batches_needed)
	emit_signal("batches_created", num_batches)


func get_slowdown():
	return 1.0 / max(num_batches, 1.0)
