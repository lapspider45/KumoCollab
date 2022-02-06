extends Pattern

var anim1:AnimationPlayer
var anim2:AnimationPlayer

func _ready():
	make_remotetransform2d(Blackboard.boss, get_child(0))
	anim1 = get_child(0).get_node_or_null("AnimationPlayer")
	anim2 = get_child(0).get_node_or_null("AnimationPlayer2")

func start():
	if anim1: anim1.play("asd")
	if anim2: anim2.play("asda")

func reset():
	pass

func stop():
	if anim1: anim1.stop()
	if anim2: anim2.stop()
