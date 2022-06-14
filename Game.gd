# this is an attempt at making the game modular
# note that this will likely break anything designed with hardcoded node paths
# and other stupid ways to make stuff. Solution: design stuff well.
extends Node



const GAME_VERTICAL_SHMUP = preload("res://game/Main.tscn")


var branches := {}


func _enter_tree():
	print("Game: Enter tree.")

func _ready():
	print("Game: Ready.")
	load_vertical_shmup()
	$Main.load_player("lana")
#	$Main.load_player("cornelia") # cornelia options not good so far on 4.0
	$Main.set_scene("res://experiments/Boss.tscn")


func set_branch(_name, _node):
	if _name in branches:
		branches[_name].queue_free()
	branches[_name] = _node
	assert(_node.name == _name)
	add_child(_node)

### Game modes

func load_vertical_shmup():
	print("loading danmaku game module")
	set_branch("Main", GAME_VERTICAL_SHMUP.instantiate())
