 extends TileMap

var data = generator.generate()
var map = data.map

onready var objs = preload("res://Objects.tscn").instance()

func floor_or_stair(c):
	var cell = get_cellv(c)
	return cell == generator.floor_id or cell == generator.stair_down_id or cell == generator.stair_up_id

func is_monster(c):
	return map[c.x][c.y].id == generator.monster

func is_player(c):
	return map[c.x][c.y].id == generator.player

func draw_single(x, y):
	var e = map[x][y].id
	if get_cell(x, y) == -1:
		if  e == generator.wall_id or e == generator.stair_down_id:
			set_cell(x, y ,e)
		elif e != -1:
			set_cell(x, y, generator.floor_id)
			match e:
				generator.monster:
					spawn_monster(Vector2(x, y))
				generator.thing:
					spawn_thing(Vector2(x, y))
				generator.yendor:
					spawn("Things/yendor", Vector2(x, y))
					
func draw_map_around(o):
	draw_single(o.x, o.y)
	draw_single(o.x, o.y-1)
	draw_single(o.x, o.y+1)
	draw_single(o.x-1, o.y)
	draw_single(o.x-1, o.y+1)
	draw_single(o.x-1, o.y-1)
	draw_single(o.x+1, o.y)
	draw_single(o.x+1, o.y+1)
	draw_single(o.x+1, o.y-1)

func spawn(path, pos):
	var node = objs.get_node(path).duplicate()
	add_child(node)
	node.set_map_pos(pos)

func spawn_monster(p):
	var monster = objs.get_node("Monster")
	var monster_count = monster.get_child_count()
	var m = monster.get_child(randi()%monster_count).duplicate()
	add_child(m)
	m.set_map_pos(p)
	map[p.x][p.y].index = m.get_index()

func spawn_thing(p):
	var things = objs.get_node("Things")
	var things_count = things.get_child_count()
	var category = things.get_child(randi()%(things_count-1)).duplicate()
	var to_spawn
	if category.name == "gold" or category.name == "food":
		to_spawn = category
	else:
		var count = category.get_child_count()
		to_spawn = category.get_child(randi()%count).duplicate()
	add_child(to_spawn)
	to_spawn.set_map_pos(p)
	
func draw_map():
	for x in range(map.size()):
		for y in range(map[0].size()):
			set_cell(x, y, map[x][y])

func _ready():
	var p = objs.get_node("Player").duplicate()
	add_child(p)
	draw_map_around(data.start_pos)
	p.set_map_pos(data.start_pos)