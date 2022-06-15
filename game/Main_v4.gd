# Main_v4.gd
extends Control

const DANMAKU_SCENE = preload("res://game/Danmaku2.tscn")

var is_setup_complete := false
signal setup_completed
func ensure_setup():
	if !is_setup_complete: await setup_completed
func complete_setup():
	is_setup_complete = true
	setup_completed.emit()

var Player:Node


func _init():
	DisplayServer.window_set_min_size(Vector2i(480, 640) + Vector2i(16,16) * 2, DisplayServer.get_window_list()[0])

func _ready():
	init_danmaku()
	
	# hack to make sure viewport is correctly sized upon game start
	%GameViewport.emit_signal("size_changed")
	complete_setup()

func start():
	load_player("cornelia")
	#set_scene("res://experiments/Boss.tscn")
	
#	%Danmaku.demo_pattern_dir("lana", 25)


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
	for _i in 3:
		await get_tree().process_frame
	Kumo.reparent(%GameViewport)
	
	Score.reparent($MarginContainer)
	Score.show()

func load_player(player_name:String):
	var player_scene: PackedScene
	match player_name:
		"lana", "cornelia":
			player_scene = load("res://game/player/%s/Player.tscn" % player_name)
		_:
			player_scene = load("res://game/player/Player.tscn") # this player is basically useless
	
	set_player(player_scene.instantiate())

func set_player(player_node:Node):
	if is_instance_valid(Player):
		Player.queue_free()
#	if !is_instance_valid(%Danmaku):
#		push_error("no Danmaku node in main scene!!!")
#		return
	Player = player_node
	%Danmaku.add_child(Player)
	Player.position = Vector2(240, 600) # spawn position

func dbg_load_pattern(path:String):
#	if !is_instance_valid(%Danmaku):
#		push_error("no Danmaku node in main scene!!!")
#		return
	%Danmaku.load_pattern(path)

func set_scene(path):
	var scn:PackedScene = load(path)
	%GameViewport.add_child(scn.instantiate())


func _exit_tree():
	# don't let these nodes get deleted, as they are used in multiple scenes
	Kumo.reparent($"/root/")
	Score.reparent($"/root/")
	Score.hide()
