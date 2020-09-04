extends Node

var amulet_lv = 3

enum {floor_id, wall_id, stair_down_id, stair_up_id, player, monster, thing, yendor}

class Block:
	var id
	func _init(id):
		self.id = id
	var index = -1

# [below, up] 区间的随机数
func randi_range(below, up):
	return (randi() % int(up+1-below)) + below

func roll(numbers, up):
	var total = 0
	for i in range(numbers):
		total += randi_range(0, up)
	return total

# 地图中随机一个地板点
func ranp_in_map(map):
	var x = randi_range(0, map.size()-1)
	var y = randi_range(0, map[0].size()-1)
	if map[x][y].id == floor_id:
		return Vector2(x, y)
	else:
		return ranp_in_map(map)

# 房间中随机一个点
func ranp_in_room(room):
	var x = randi_range(room.position.x+1, room.end.x-2)
	var y = randi_range(room.position.y+1, room.end.y-2)
	return Vector2(x, y)

# 任意两点的水平向量
func hline(x1, x2, y):
	var line = []
	for x in range(min(x1, x2), max(x1, x2)+1):
		line.append(Vector2(x, y))
	return line

# 任意两点的垂直向量
func vline(y1, y2, x):
	var line = []
	for y in range(min(y1, y2), max(y1, y2)+1):
		line.append(Vector2(x, y))
	return line

func too_close(a, b):
	var ap = a.position
	var ae = a.end
	var bp = b.position
	var be = b.end
	return abs(ae.y-bp.y) == 0 or abs(ap.x-be.x) == 0 or abs(ap.y-be.y) == 0 or abs(ae.x-bp.x) == 0
	
# 和任意已有房间相交
func intersect_with_exists(new, exists):
	if exists.empty():
		return false
	for room in exists:
		if new.intersects(room) or too_close(new, room):
			return true
	return false

func gen_map(map_size = Vector2(80, 24), room_size = Vector2(20,8), max_tries = 12):
	randomize()

	# 初始化地图
	var map = []
	for x in range(map_size.x):
		var col = []
		for y in range(map_size.y):
			col.append(Block.new(-1))
		map.append(col)

	# 生成房间
	var rooms = []
	for r in range(max_tries):
		var w = randi_range(4, room_size.x)
		var h = randi_range(4, room_size.y)
		var x = randi_range(0, map_size.x-w-1)
		var y = randi_range(0, map_size.y-h-1)
		var new = Rect2(x, y, w, h)

		if not intersect_with_exists(new, rooms):
			rooms.append(new)

	# 房间放到地图上
	for r in rooms:
		var start = r.position
		var end = r.end
		for x in range(start.x, end.x):
			for y in range(start.y, end.y):
				if x == start.x or x == end.x-1 or y == start.y or y == end.y-1:
					map[x][y] = Block.new(wall_id)
				else:
					map[x][y] = Block.new(floor_id)

	# 生成房间间的通路
	for i in range(1, rooms.size()):
		var cur = ranp_in_room(rooms[i])
		var prv = ranp_in_room(rooms[i-1])

		if randi() % 2 == 0:
			for c in hline(cur.x, prv.x, cur.y):
				map[c.x][c.y] = Block.new(floor_id)
			for c in vline(cur.y, prv.y, prv.x):
				map[c.x][c.y] = Block.new(floor_id)
		else:
			for c in vline(cur.y, prv.y, cur.x):
				map[c.x][c.y] = Block.new(floor_id)
			for c in hline(cur.x, prv.x, prv.y):
				map[c.x][c.y] = Block.new(floor_id)
	return [map, rooms]

func generate(monster_count = 8, thing_count = 100):
	var data = gen_map()
	var map = data[0]
	var rooms = data[1]

	# 玩家出生点
	var player_pos = ranp_in_room(rooms[randi()%rooms.size()])
	map[player_pos.x][player_pos.y] = Block.new(player)

	# 下层入口
	if status.Level != amulet_lv:
		var stair_down_pos = ranp_in_room(rooms[randi()%rooms.size()])
		map[stair_down_pos.x][stair_down_pos.y] = Block.new(stair_down_id)

	# 怪物出生点
	for i in range(randi_range(1, monster_count)):
		var p = ranp_in_map(map)
		map[p.x][p.y] = Block.new(monster)

	# 物品出生点
	for i in range(randi_range(1, thing_count)):
		var p = ranp_in_map(map)
		map[p.x][p.y] = Block.new(thing)

	# 护身符
	if status.Level == amulet_lv:
		var p = ranp_in_map(map)
		map[p.x][p.y] = Block.new(yendor)
		
	return {"map":map,
			"start_pos":player_pos}

func _ready():
	pass