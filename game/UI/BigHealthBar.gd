extends MarginContainer

var enemy: Node

func _ready():
	Blackboard.boss_healthbar = self
	Blackboard.emit_signal("nodes_updated")


func set_enemy(e:Node):
	enemy = e
	show()

func set_max(m):
	$ProgressBar.max_value = m

func _process(delta):
	if is_instance_valid(enemy):
		if enemy.get("hp") != null:
			$ProgressBar.value = enemy.hp
	else:
		hide()
