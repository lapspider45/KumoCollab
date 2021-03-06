extends "Main.gd"

func _ready():
	# Interesting fact: In Godot 3: the parent class _ready gets called before the child class
	Danmaku.load_pattern("lana/LanaRecursive")
	set_process(true)

func load_pattern():
	pass

func start():
	pass

func _process(delta):
	if is_instance_valid(GameViewport):
		Blackboard.player_pos = clip_vec(GameViewport.get_mouse_position(), Rect2(Vector2.ZERO, GameViewport.size).grow(-32))

func init_danmaku():
	# todo: check that this isn't run twice
	var _danmaku:Node = DANMAKU_SCENE.instance()
	_danmaku.name = "Danmaku"
	GameViewport.add_child(_danmaku)
	Danmaku = _danmaku
	
	yield(get_tree(), "idle_frame")
	Kumo.reparent(GameViewport)


static func clip_vec(vec:Vector2, rect:Rect2)->Vector2:
	return Vector2(
		clamp(vec.x, rect.position.x, rect.end.x),
		clamp(vec.y, rect.position.y, rect.end.y)
	)
