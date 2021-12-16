extends Pattern

var anim1:AnimationPlayer
var anim2:AnimationPlayer

func _ready():
	anim1 = get_child(0).get_node("AnimationPlayer")
	anim2 = get_child(0).get_node("AnimationPlayer2")

func start():
	if anim1: anim1.play("asd")
	if anim2: anim2.play("asda")

func reset():
	pass

func stop():
	if anim1: anim1.stop()
	if anim2: anim2.stop()
