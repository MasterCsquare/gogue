extends TileMap

var items = status.items
var empty = ""
var size = Vector2(8, 6)

func _ready():
	var p = get_node("/root/UI/Game/Dungeon/Viewport/Map/Player")
	if items.empty():
		init(size.y, size.x)
	else:
		print(items)
		load_items()

func init(lines, cols):
	for i in range(cols):
		items.append([])
	for col in items:
		for i in range(lines):
			col.append(empty)

func get_empty_slot():
	for x in range(size.x):
		for y in range(size.y):
			if items[x][y] == empty:
				return Vector2(x, y)

onready var game = get_node("/root/UI/Game")

func add_item(node):
	var name = remove_end_numbers(node.name)
	print(node.name)
	print(name)
	if name == "gold":
		status.Gold += 10
		game.update_gold()
		return true
	else:
		var e = get_empty_slot()
		if e is Vector2:
			var n = things.find_node(name, true).duplicate()
			add_child(n)
			n.set_position(map_to_world(e))
			items[e.x][e.y] = remove_end_numbers(node.name)
			return true
		else:
			game.update_message("背包已满")
			return false

func load_items():
	for x in range(size.x):
		for y in range(size.y):
			var i = items[x][y]
			if i != empty:
				var n = things.find_node(i, true).duplicate()
				add_child(n)
				n.set_position(map_to_world(Vector2(x, y)))
	if not status.no_arm():
		set_cellv(status.arm_pos, 1)
	if not status.no_wep():
		set_cellv(status.wep_pos, 1)

func remove_end_numbers(s):
	s = s.replace("0", "")
	s = s.replace("1", "")
	s = s.replace("2", "")
	s = s.replace("3", "")
	s = s.replace("4", "")
	s = s.replace("5", "")
	s = s.replace("6", "")
	s = s.replace("7", "")
	s = s.replace("8", "")
	s = s.replace("9", "")
	return s.replace("@", "")

onready var cursor = get_node("../cursor")
onready var selected = get_node("../selected")
signal item_selected(name)

func _on_slots_gui_input(e):
	if e is InputEventMouseMotion:
		var c = world_to_map(e.position)
		cursor.set_position(map_to_world(c))
		cursor.show()
	elif e is InputEventMouseButton and e.button_index == BUTTON_LEFT and e.pressed:
		var c = world_to_map(e.position)
		selected.set_position(map_to_world(c))
		selected.show()
		emit_signal("item_selected", c)

func _on_slots_mouse_exited():
	cursor.hide()