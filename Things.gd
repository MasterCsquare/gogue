extends "res://Objects.gd"

onready var inventory = get_node("/root/UI/Inventory/slots/slot")
export(String) var description

func picked():
	if get_map_pos() == status.pos:
		var not_full = inventory.add_item(get_node("."))
		if not_full:
			queue_free()
	
func _ready():
	var p = get_node("../Player")
	if p:
		p.connect("pick_up", self, "picked")