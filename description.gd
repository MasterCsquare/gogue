extends Label


func _on_slot_item_selected(c):
	var name = status.items[c.x][c.y]
	if not name.empty():
		var item = things.find_node(name, true)
		self.text = item.description()