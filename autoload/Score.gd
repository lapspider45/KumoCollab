# Score.gd
# A score/hiscore manager node.
# WIP
extends Label

signal score_changed
signal hiscore_changed


var score:int = 0 # Don't set this value directly, use one of the functions
var hiscore:int = 0 # same for this var

func _ready():
	score_changed.connect(update_display)
	hiscore_changed.connect(update_display)


# Adds x to the current score.
# Example usage:
# [enemy scene]
# func die():
#		Score.increment(points_value)
func increment(x:int):
	score += x
	emit_signal("score_changed")



func set_score(v:int):
	score = v
	emit_signal("score_changed")

func set_hiscore(v:int):
	hiscore = v
	emit_signal("hiscore_changed")

func format_score(v:int):
	@warning_ignore(integer_division)
	return "%3d %03d %03d" % [v/1000000, v/1000 % 1000, v % 1000]

func update_display():
	text = "  score: %s\nhiscore: %s" % [
		format_score(score),
		format_score(hiscore)
	]

func reparent(to:Node):
	get_parent().remove_child(self)
	to.add_child(self)
