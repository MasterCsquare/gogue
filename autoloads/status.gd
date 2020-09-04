extends Node

var items = []
var Level = 1
var Prev_levels = []
var HP = 12
var Exp = 0
var Str = 16
var Base_arm = 4
var Arm = 4
var Gold = 0
var invalid = Vector2(-1, -1)
var pos = invalid
var arm_pos = invalid
var wep_pos = invalid

func init():
	items.clear()
	Level = 1
	Prev_levels = []
	HP = 12
	Exp = 0
	Str = 16
	Base_arm = 4
	Arm = 4
	Gold = 0
	pos = invalid
	arm_pos = invalid
	wep_pos = invalid

func none(p):
	return p == invalid

func no_arm():
	return none(arm_pos)

func no_wep():
	return none(wep_pos)
	
func _ready():
	pass