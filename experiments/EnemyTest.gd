extends Node2D

signal tick(delta)

func _connect():
	connect("tick", $Player, "_custom_process")
	connect("tick", $Enemy, "advance")

func _process(delta):
	emit_signal("tick", delta)
	$SimpleBulletServer.process_bullets(delta)


func add_bullet(b:Node):
#	connect("tick", b, "_custom_process")
	$SimpleBulletServer.add_bullet(b)

func _ready():
	_connect()
