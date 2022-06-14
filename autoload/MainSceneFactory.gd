# this node is useful for testing stuff via the "play scene" button in the editor
# when the main scene is a scene from the res://game/patterns/ dir, it will
# load the main scene and load the pattern for testing instead
extends Node

func _ready():
	check_main_scene()
#	if OS.has_feature("debug"):
#		check_main_scene()
#	else:
#		queue_free()

func check_main_scene():
	var main := get_tree().current_scene
	if !is_instance_valid(main):
		return
	if main.is_in_group("MainScene"):
		return
#	print("factory: main scene is %s" % [main])
#	
	var path = main.scene_file_path
#	print("factory: main scene was loaded from %s" % path)
	if path.begins_with("res://game/patterns/"):
		redirect_scene_to_pattern(path)
	if path.begins_with("res://experiments/"):
		redirect_test_scene(path)


func redirect_scene_to_pattern(path:String):
	print("redirecting main scene and loading %s" % path)
	var err = get_tree().change_scene("res://game/Main.tscn")
	await get_tree().process_frame # according to the docs, new scene is available on the next frame
	var main = get_tree().current_scene
	print("factory: main scene was redirected to %s" % [main])
	
	# load the pattern
	main.dbg_load_pattern(path)

func redirect_test_scene(path:String):
	print("redirecting main scene and loading %s" % path)
	var err = get_tree().change_scene("res://game/Main.tscn")
	await get_tree().process_frame # according to the docs, new scene is available on the next frame
	var main = get_tree().current_scene
	print("factory: main scene was redirected to %s" % [main])
	
	# load the scene
	var scn:PackedScene = load(path)
	main.get_node(
		"AspectRatioContainer/MarginContainer/ViewportContainer/GameViewport"
		).add_child(scn.instantiate())
