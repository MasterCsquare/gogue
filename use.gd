extends Button

var cell
var cata
var equip = 1
var normal = 0

onready var inventory = get_node("../slots/slot")
onready var game = get_node("/root/UI/Game")

func _pressed():
	var item
	var children = inventory.get_children()
	for child in children:
		if child.get_inv_pos() == cell:
			item = child
	match cata:
		"armor", "weapon":
			var state = inventory.get_cellv(cell)
			if state == normal:
				inventory.set_cellv(cell, equip)
				if cata == "armor":
					if not status.no_arm():
						inventory.set_cellv(status.arm_pos, normal)
					status.Arm = item.armor + status.Base_arm
					game.update_arm()
					status.arm_pos = cell
				if cata == "weapon":
					if not status.no_wep():
						inventory.set_cellv(status.wep_pos, normal)
					status.wep_pos = cell
				text = "卸下"
			else:
				inventory.set_cellv(cell, normal)
				if cata == "armor":
					status.Arm = status.Base_arm
					game.update_arm()
					status.arm_pos = status.invalid
				if cata == "weapon":
					status.wep_pos = status.invalid
				text = "装备"
				
func _on_slot_item_selected(c):
	cell = c
	var item = status.items[c.x][c.y]
	if not item.empty():
		cata = things.find_node(status.items[c.x][c.y]).get_parent().name
		match cata:
			"armor", "ring", "weapon":
				if inventory.get_cellv(c) != equip:
					text = "装备"
				else:
					text = "卸下"
			"potions":
				text = "喝"
			"scrolls":
				text = "阅读"
			"things":
				text = "吃"
				if item == "yendor":
					text = "查看"
			"wand":
				text = "施放魔法"
	pass 