extends "res://Objects.gd"

signal move
signal next_level
signal monster_update
signal monster_round
signal pick_up
signal player_attack(msg)

func _ready():
	set_process_input(true)

func move1(d):
	var p = get_map_pos()
	var new_cell = p + DIRECTION[d]
	if map.floor_or_stair(new_cell) and not map.is_monster(new_cell):
		map.draw_map_around(new_cell)
		set_map_pos(new_cell)
		update_pos(p)
		emit_signal("move")
	elif map.is_monster(new_cell):
		fight(new_cell)

func fight(pos):
	emit_signal("monster_update")
	var monster = map.get_child(map.map[pos.x][pos.y].index)
	monster.Hp -= 5
	emit_signal("player_attack", "你对" + monster.monster_name + "造成5点伤害")
	if monster.Hp <= 0:
		monster.free()
		map.map[pos.x][pos.y].id = generator.floor_id
		emit_signal("monster_update")
	emit_signal("monster_round")

func greed_move(d):
	while true:
		var curr = get_map_pos()
		move1(d)
		var next = get_map_pos()
		if curr == next:
			break

func next_level():
	if map.get_cellv(get_map_pos()) == generator.stair_down_id:
		status.Level += 1
		status.Prev_levels.append(map.map)
		get_tree().reload_current_scene()
		emit_signal("next_level")

func update_pos(old):
	var p = get_map_pos()
	status.pos = p
	map.map[p.x][p.y].id = generator.player
	map.map[old.x][old.y].id = generator.floor_id

func _input(event):

	if Input.is_action_pressed("dir_left"): move1("L")
	elif Input.is_action_pressed("dir_down"): move1("D")
	elif Input.is_action_pressed("dir_right"): move1("R")
	elif Input.is_action_pressed("dir_up"): move1("U")
	elif Input.is_action_pressed("dir_left_down"): move1("LD")
	elif Input.is_action_pressed("dir_left_up"): move1("LU")
	elif Input.is_action_pressed("dir_right_down"): move1("RD")
	elif Input.is_action_pressed("dir_right_up"): move1("RU")

	if event.is_action_pressed("shift_left"): greed_move("L")
	elif event.is_action_pressed("shift_down"): greed_move("D")
	elif event.is_action_pressed("shift_right"): greed_move("R")
	elif event.is_action_pressed("shift_up"): greed_move("U")
	elif event.is_action_pressed("shift_left_down"): greed_move("LD")
	elif event.is_action_pressed("shift_left_up"): greed_move("LU")
	elif event.is_action_pressed("shift_right_down"): greed_move("RD")
	elif event.is_action_pressed("shift_right_up"): greed_move("RU")

	if event.is_action_pressed("next_level"): next_level()

	if event.is_action_pressed("pick_up"): emit_signal("pick_up")
