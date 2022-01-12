extends Node2D

const SFX_DIR = "res://sfx/"

var stereo_width = 0.75
var sfx_list := {}

func _ready():
	preload_sfx()
	for sfx in sfx_list:
		setup_player_2d(sfx)

func preload_sfx():
	var dir = DirUtils.new()
	dir.open(SFX_DIR)
	for entry in dir.ls():
		var res_path:String = entry.path.trim_suffix(".import")
#		print("preloading SFX: %s" % res_path)
		var sfx_name = res_path.get_file().get_basename()
		var stream:AudioStream = load(res_path)
		sfx_list[sfx_name] = stream
	print("preloaded sfx: %s" % [sfx_list.keys()])


func setup_player(sfx_name:String):
	var player = AudioStreamPlayer.new()
	
	player.name = sfx_name
	player.stream = sfx_list.get(sfx_name)
	assert(player.stream is AudioStream, "Something went wrong, possibly there is no SFX of that name")
	add_child(player)

func setup_player_2d(sfx_name:String):
	var player = AudioStreamPlayer2D.new()
	
	player.name = sfx_name
	player.stream = sfx_list.get(sfx_name)
	assert(player.stream is AudioStream, "Something went wrong, possibly there is no SFX of that name")
	add_child(player)

func set_pool_size(sfx_name:String, size:int):
	# Pooling is not implemented yet, but here are some considerations:
	# 1. Limit the number of sounds playing at once
	# 2. Don't spawn the same sfx more than once in the same frame
	breakpoint # implement me

# Play a sound effect. `sfx_name` must be the filename (without extension) of a file which is located inside res://sfx.
# The `pan_position` argument is optional, `-1.0` is hard left, `+1.0` is hard right.
# If you have more advanced needs, use AudioStreamPlayer nodes directly.
func play(sfx_name:String, pan_position:=0.0):
	var player = get_node_or_null(sfx_name)
	if player is AudioStreamPlayer2D:
		var vrect := get_viewport_rect()
		var transformed_position = (vrect.position + vrect.size * 0.5) + vrect.size * pan_position * stereo_width * Vector2(0.5, 0) # this is a mess but basically it transforms pan_position into the format required by godot
		player.position = transformed_position
		player.play()
	else:
		push_error("[SFX] A sound effect with the name '%s' was not found." % sfx_name)
