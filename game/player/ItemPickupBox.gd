extends Area2D

export var item_collection_line := 200

func _on_ItemPickupBox_area_entered(area):
	area.item_pickup_box_found = self


func _physics_process(delta):
	if global_position.y < item_collection_line:
		for i in get_tree().get_nodes_in_group("item"):
			i.item_pickup_box_found = self
