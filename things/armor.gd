extends "res://things/things.gd"

export(int) var armor
export(String) var armor_name

func description():
	return String(armor_name) + "\n" + "护甲：+" + String(armor)