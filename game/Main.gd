extends Control

const DANMAKU_SCENE = preload("res://game/Danmaku2.tscn")

var Danmaku:Node
var Player:Node

func _init():
	DisplayServer.window_set_min_size(Vector2i(480, 640)/2 + Vector2i(16,16) * 2, 0)

func _ready():
	init_danmaku()
	set_player("lana")
#	Danmaku.demo_pattern_dir("lana", 25)

func _unhandled_key_input(event):
	if event.is_action_pressed("restart"):
		print("RESTARTING NOW!")
		get_tree().reload_current_scene()
	if event.is_action_pressed("DEBUG_FULLSCREEN"):
		OS.window_fullscreen = not OS.window_fullscreen
	if event.is_action_pressed("DEBUG_QUIT"):
		print("DEBUG_QUIT key pressed, quitting...")
		get_tree().quit()


func init_danmaku():
	var game_viewport = $AspectRatioContainer/MarginContainer/ViewportContainer/GameViewport
	game_viewport.size_changed.emit() # correct size at init of game
	# todo: check that this isn't run twice
	var _danmaku:Node = DANMAKU_SCENE.instantiate()
	_danmaku.name = "Danmaku"
	game_viewport.add_child(_danmaku)
	Danmaku = _danmaku
	
	await get_tree().process_frame
	DanmakuServer.reparent(game_viewport)
	

func set_player(player_name:String):
	var player_scene: PackedScene
	match player_name:
		"lana", "cornelia":
			player_scene = load("res://game/player/%s/Player.tscn" % player_name)
		_:
			player_scene = load("res://game/player/Player.tscn") # this player is basically useless
	
	if is_instance_valid(Player):
		Player.queue_free()
	if !is_instance_valid(Danmaku):
		push_error("no Danmaku node in main scene!!!")
		return
	Player = player_scene.instantiate()
	Danmaku.add_child(Player)
	Player.position = Vector2(240, 600) # spawn position

func dbg_load_pattern(path:String):
	if !is_instance_valid(Danmaku):
		push_error("no Danmaku node in main scene!!!")
		return
	Danmaku.load_pattern(path)
