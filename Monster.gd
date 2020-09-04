extends "res://Objects.gd"

export(int) var Exp
export(int) var Lv
export(int) var Arm
export(int) var Min_dmg
export(int) var Max_dmg
export(String) var monster_name

onready var game = get_node("/root/UI/Game")
#var Hp = generator.roll(Lv, 8)
var Hp = 7
func fight():
	var p = get_map_pos()
	if p.distance_squared_to(status.pos) <= 2:
		status.HP -= 1
		game.update_message(self.monster_name + "对你造成了1点伤害")
		get_node("/root/UI/Game").update_hp()
		if status.HP <= 0:
			get_tree().change_scene("res://mechanism/RIP.tscn")
			
func move1(d):
	var p = get_map_pos()
	var new_cell = p + DIRECTION[d]
	if map.floor_or_stair(new_cell) and not map.is_monster(new_cell) and not map.is_player(new_cell):
		set_map_pos(new_cell)
		update_pos(p)

func update_pos(old):
	var p = get_map_pos()
	map.map[p.x][p.y].id = generator.monster
	map.map[p.x][p.y].index = map.map[old.x][old.y].index
	map.map[old.x][old.y].id = generator.floor_id
			
func chase():
	var my_pos = get_map_pos()
	var rel = status.pos - my_pos
	if rel.x == 0:
		if rel.y > 0:
			move1("D")
		if rel.y < 0:
			move1("U")
	if rel.x > 0:
		if rel.y == 0:
			move1("R")
		if rel.y < 0:
			move1("RU")
		if rel.y > 0:
			move1("RD")
	if rel.x < 0:
		if rel.y == 0:
			move1("L")
		if rel.y < 0:
			move1("LU")
		if rel.y > 0:
			move1("LD")		

func update_index():
	var p = get_map_pos()
	map.map[p.x][p.y].index = get_index()
	
func _ready():
	var p = get_node("../Player")
	p.connect("move", self, "chase")
	p.connect("monster_update", self, "update_index")
	p.connect("monster_round", self, "fight")