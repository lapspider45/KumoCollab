extends Area2D

export var speed = 150
var direction := Vector2.DOWN
var item_pickup_box_found : Area2D = null 


func _physics_process(delta):
	if item_pickup_box_found :
		_homing()
	position += direction * speed * delta


func _homing():
	var difference = item_pickup_box_found.global_position - position
	direction = (difference).normalized() * 4


func _on_Item_area_entered(area):
	print("Power Up")
	queue_free()
