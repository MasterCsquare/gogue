extends Button

func _ready():
	pass 

func _pressed():
	status.init()
	get_tree().change_scene("res://UI.tscn")
	get_node("/root/BgmScene").play()