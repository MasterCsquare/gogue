extends Button

var item
var cell
onready var inventory = get_node("../slots/slot")
onready var map = get_node("/root/UI/Game/Dungeon/Viewport/Map")
onready var objs = preload("res://Objects.tscn").instance()

func _on_slot_item_selected(c):
	cell = c
	var children = inventory.get_children()
	for child in children:
		if child.get_inv_pos() == c:
			item = child
	pass

var normal = 0
func _pressed():
	if cell is Vector2 and not status.items[cell.x][cell.y].empty():
		var copy = objs.find_node(inventory.remove_end_numbers(item.name), true).duplicate()
		map.add_child(copy)
		copy.set_map_pos(status.pos)
		item.free()
		status.items[cell.x][cell.y] = ""
		if cell == status.arm_pos:
			inventory.set_cellv(cell, normal)
			status.arm_pos = status.invalid
		if cell == status.wep_pos:
			inventory.set_cellv(cell, normal)
			status.wep_pos = status.invalid