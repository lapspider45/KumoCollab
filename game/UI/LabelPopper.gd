# this is some complicated code, avoid touching it
# more specifically, it contains a system to mitigate stutter from spawning
# a large number of score popups by merging them together based on proximity
# and staggering their spawns in time
extends Node2D

const POPUP = preload("res://game/UI/ScorePopup.tscn")

var frame:int = 0
@export var frame_period:int = 7

var popup_buckets = {}

func _ready():
	Registry.register("LabelPopper", self)

func popup_at(vec:Vector2, number):
	var pp = POPUP.instantiate()
	add_child(pp)
	pp.set_value(number)
	pp.popup_at(vec)

func queue_popup(vec:Vector2, number):
	var bucket := ghetto_spatial_hash(vec)
	if not popup_buckets.get(bucket) is Array:
		popup_buckets[bucket] = []
	popup_buckets[bucket].append_array([vec, number])

func _process(_delta):
	frame += 1

	# process the buckets that belong to this frame
	for k in popup_buckets: if (k + frame) % frame_period == 0:
		var bucket = popup_buckets.get(k)
		if not bucket is Array:
			continue
		var total = 0
		var pos: Vector2
		while bucket.size() >= 2:
			total += bucket.pop_back()
			pos = bucket.pop_back()
		popup_at(pos, total)
		popup_buckets[k] = null


# used for merging score popups, turns a position into a number 
# which is the same for positions close together
static func ghetto_spatial_hash(vec:Vector2)->int:
	return int(vec.x / 32) + 64 * int(vec.y / 32)
