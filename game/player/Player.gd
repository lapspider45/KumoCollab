extends Node2D

export var MOVE_SPEED := 150
export var SLOW_SPEED := 75


export var bullet_speed := 100 setget set_bullet_speed

var main:Node = null

var velocity := Vector2.ZERO

export var invincible := false setget set_invincible

export var screen_rect := Rect2(0,0,480,640)

export var max_hp := 30
onready var hp = max_hp

var bullets = []


func _ready():
	setup_guns()
	set_invincible(false)


func get_movement_dir()-> Vector2:
	var vec = Input.get_vector("left", "right", "up", "down")
	var joy_vec = Input.get_vector("joy_left", "joy_right", "joy_up", "joy_down")
	
	if joy_vec.length() > vec.length(): # workaround for a deadzone bug
		return joy_vec
	else:
		return vec

func shoot():
#	get_tree().call_group("player_bulletspawner", "shoot")
	for g in $Guns.get_children():
		g.shoot()

func add_bullet(bullet):
	bullet.set_collision_layers(8)
	DanmakuServer.add_bullet(bullet)


func _physics_process(_delta):
	update_blackboard()

func advance(delta):
	var speed := MOVE_SPEED
	if Input.is_action_pressed("slow"):
		speed = SLOW_SPEED
	
	velocity = get_movement_dir() * speed
	translate(velocity * delta)
	
	set_shooting(Input.is_action_pressed("shoot"))
	
	global_position = clip_vec(global_position, screen_rect)
	
	$ShootAnimation.advance(delta * Blackboard.slowdown)

func set_shooting(shoot:bool):
	if shoot:
		$ShootAnimation.play("shoot")
	else:
		$ShootAnimation.stop()

#func _on_collision():
#	hurt()

func hurt(dmg:=1):
	if invincible:
		return
	invincible = true
	$ExplosionParticles1.restart()
	print("player got hit")
	print("ouch for %d dmg" % dmg)
	hp -= 1
#	Global.emit_signal("player_health_changed", hp)
#	if hp <= 0:
#		Global.emit_signal("player_died")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("invincible")
#	$hurtSFX.play()

#func _on_Player_area_shape_entered(area_id, area, area_shape, self_shape):
#	_on_collision()

func set_invincible(v:bool):
#	$Hitbox.set_deferred("monitoring", v)
	invincible = v


func update_blackboard():
	Blackboard.player_pos = global_position
	Blackboard.predicted_player_pos = global_position + velocity

static func clip_vec(vec:Vector2, rect:Rect2)->Vector2:
	return Vector2(
		clamp(vec.x, rect.position.x, rect.end.x),
		clamp(vec.y, rect.position.y, rect.end.y)
	)

func get_spawners():
	if not is_inside_tree(): return []
	return get_tree().get_nodes_in_group("player_bulletspawner")

func set_bullet_speed(v):
	bullet_speed = v
	for s in get_spawners():
		s.bullet_speed = v

func setup_guns():
	for g in $Guns.get_children():
		g.set_bullet_collision(8)
