extends Label

signal started
signal timeout

var time_remaining:float
var active := false

func _init():
	add_to_group("autoadvance")

func _ready():
	Blackboard.pattern_timer = self
	Blackboard.emit_signal("nodes_updated")

func as_text():
	return "%02d" % ceil(time_remaining)

func start_timer(time:float):
	time_remaining = time
	active = true
	enable()
	emit_signal("started")
	await timeout

func enable():
	show()
	$AnimationPlayer.play("RESET")

func disable():
	active = false
	emit_signal("timeout")
	$AnimationPlayer.play("fadeout")

func advance(delta:float):
	if active:
		time_remaining -= delta
		text = as_text()
	if time_remaining <= 0.0:
		active = false
		emit_signal("timeout")
#		$AnimationPlayer.play("timeout_flash")
