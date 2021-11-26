extends Node2D

var BULLETS

func _ready():
	BULLETS = $SimpleBulletServer
	Registry.register("current_gamescene", self)
	$SimpleBulletServer.connect("bullet_collided", self, "on_collision")

func _process(delta):
	var slowdown:float = 1.0 / max(BULLETS.num_batches, 1)
	Blackboard.slowdown = slowdown
	$SimpleBulletServer.process_bullets(delta)
	get_tree().call_group("TickedAnimationPlayer", "advance", delta * slowdown)
	$Player._custom_process(delta * slowdown)
#	if $SimpleBulletServer.batch_finished:

func add_bullet(bullet):
	$SimpleBulletServer.add_bullet(bullet)

func on_collision(bullet):
#	print("collision with %s!" % bullet)
	$SimpleBulletServer.clear_bullets()
