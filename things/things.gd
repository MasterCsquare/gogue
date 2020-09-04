extends Node2D

export(String) var item_name
onready var inv = get_node("/root/UI/Inventory/slots/slot")

func description():
	return item_name
	
func get_inv_pos():
	return inv.world_to_map(get_position())

func set_inv_pos(cell):
	set_position(inv.map_to_world(cell))