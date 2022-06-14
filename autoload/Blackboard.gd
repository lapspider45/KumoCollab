# Blackboard.gd
# A singleton useful for sharing data with multiple nodes
extends Node

# warning-ignore:unused_signal
signal nodes_updated

# TODO: this stuff is outdated

var SCREEN = { # this dictionary has some useful points for manipulating stuff on the screen
	TOPLEFT = Vector2(),
	TOPRIGHT = Vector2(),
	BOTTOMLEFT = Vector2(),
	BOTTOMRIGHT = Vector2(),
	
	CENTER = Vector2(),
	TOPCENTER = Vector2(),
	BOTTOMCENTER = Vector2(),
	
	SIZE = Vector2(),
}

func get_bullet_limits():
	return Rect2(SCREEN.TOPLEFT, SCREEN.SIZE)

static func avg(a, b):
	return (a + b) * 0.5

func init_screen_points(left, right, top, bottom):
	SCREEN.TOPLEFT = Vector2(left, top)
	SCREEN.TOPRIGHT = Vector2(right, top)
	SCREEN.BOTTOMLEFT = Vector2(left, bottom)
	SCREEN.BOTTOMRIGHT = Vector2(right, bottom)
	
	SCREEN.CENTER = avg(SCREEN.TOPLEFT, SCREEN.BOTTOMRIGHT)
	SCREEN.TOPCENTER = Vector2(avg(left, right), top)
	SCREEN.BOTTOMCENTER = Vector2(avg(left, right), bottom)
	
	SCREEN.SIZE = Vector2(right-left, bottom-top)

func init_screen_rect(rect:Rect2):
	init_screen_points(rect.position.x, rect.end.x, rect.position.y, rect.end.y)
	enemy_death_rect = rect.grow(1000) # enemies will be deleted when 1000 pixels outside of the screen

## these values are to be pushed by the player, so if there is no player they are simply ZERO
var player_pos : Vector2  = Vector2(240, 900) # position of the player
var predicted_player_pos : Vector2 # position of the player 1 second into future based on current velocity
func predict_player_pos(delta:float) -> Vector2: # position of the player 'delta' seconds into the future
#	print("predicted: %s" % player_pos.lerp(predicted_player_pos, delta))
	return player_pos.lerp(predicted_player_pos, delta)

var player_autoaim_target : Vector2 # position which player's autoaim targets
var player_pickup_radius = 48.0
var player_pickup_line = 200

var slowdown = 1 # multiply with delta

var boss : Node
var boss_pos : Vector2

var fields = {}
var FIELD_EMPTY = VectorField.new()

var enemy_death_rect : Rect2

var pattern_timer : Node # the visible countdown that times out a boss pattern or bonus section
var boss_healthbar : Node # boss healthbar

func start_timeout(time:float):
	while !is_instance_valid(pattern_timer):
		await nodes_updated
	await pattern_timer.start_timer(time)

func stop_timeout():
	pattern_timer.disable()


func show_healthbar_for(enemy:Node, max_hp:int):
	assert(enemy.get("hp") != null)
	while !is_instance_valid(boss_healthbar):
		await nodes_updated
	boss_healthbar.set_max(max_hp)
	boss_healthbar.set_enemy(enemy)
