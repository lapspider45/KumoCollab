extends Node2D

func _ready():
	Registry.register("current_gamescene", self)
	$SimpleBulletServer.connect("bullet_collided", self, "on_collision")

func _process(delta):
	var slowdown:float = 1.0 / max(DanmakuServer.current_server.num_batches, 1)
	Blackboard.slowdown = slowdown
	$SimpleBulletServer.process_bullets(delta)
	get_tree().call_group("TickedAnimationPlayer", "advance", delta * slowdown)
#	$Player.advance(delta * slowdown)
#	if $SimpleBulletServer.batch_finished:

func add_bullet(bullet):
	$SimpleBulletServer.add_bullet(bullet)

func on_collision(_bullet):
#	print("collision with %s!" % bullet)
	$SimpleBulletServer.clear_bullets()
