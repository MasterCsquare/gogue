extends "res://things/things.gd"

export(int) var attack

func description():
	return String(item_name) + "\n" + "攻击力：+" + String(attack)
