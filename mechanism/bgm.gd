extends AudioStreamPlayer

func _ready():
	get_node("/root/BgmScene").stop()
	play()