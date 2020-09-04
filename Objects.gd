extends Node2D

func _ready():
	pass
	
onready var map = get_node("/root/UI/Game/Dungeon/Viewport/Map")

const DIRECTION = {
	"L": Vector2(-1, 0),
	"R": Vector2(1, 0),
	"U": Vector2(0, -1),
	"D": Vector2(0, 1),
	"LU": Vector2(-1, -1),
	"RU": Vector2(1, -1),
	"LD": Vector2(-1, 1),
	"RD": Vector2(1, 1)
}

func move1(d):
	var new_cell = get_map_pos() + DIRECTION[d]
	set_map_pos(new_cell)
		
func get_map_pos():
	return map.world_to_map(get_position())

func set_map_pos(cell):
	set_position(map.map_to_world(cell))