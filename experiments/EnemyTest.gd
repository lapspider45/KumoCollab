extends Node2D

export var enemy_scene:PackedScene = preload("res://game/enemies/Enemy.tscn")
export var spawn_offset := Vector2.ZERO
export var max_enemies := 3
export var enemy_behavior := "chase_player"

func _ready():
	Kumo.connect("bullet_hit", self, "bullet_hit_sfx")

func bullet_hit_sfx(bullet):
	
	var vrect := get_viewport_rect()
	var pan_position := 2 * (inverse_lerp(vrect.position.x, vrect.end.x, bullet.position.x) - 0.5)
	
	SFX.play("hit", pan_position)

func _physics_process(delta):
	for c in get_tree().get_nodes_in_group(get_unique_group("spawned")):
		c.advance(delta)

func turn_up_the_heat():
	max_enemies += 1
	$AnimationPlayer.playback_speed += 0.2

func _spawn():
	if get_tree().get_nodes_in_group(get_unique_group("spawned")).size() >= max_enemies:
		return
	var e := spawn_enemy(enemy_scene.instance(), spawn_offset)
	e.add_to_group(get_unique_group("spawned"))
#	e.movement_mode = Enemy.MOVE.CHASE_PLAYER

### Enemy / Entity spawning code
# maybe this should be moved to another node
func spawn_enemy(enemy_instance:Enemy, pos:Vector2)->Enemy:
	enemy_instance.position = pos
	add_child(enemy_instance)
	enemy_instance.on_spawn()
	enemy_instance.set_behavior(enemy_behavior)
	return enemy_instance


func get_unique_group(prefix:String = name)-> String:
	return "%s@%d" % [prefix, get_instance_id()]
