extends VBoxContainer

onready var message = $MessageMargin/Message
onready var lv = $StatusMargin/Status/Level
onready var gold = $StatusMargin/Status/Gold
onready var hp = $StatusMargin/Status/Hp
onready var stre = $StatusMargin/Status/Str
onready var arm = $StatusMargin/Status/Arm
onready var expi = $StatusMargin/Status/Exp
onready var timer = $MessageMargin/Timer

onready var p = get_node("/root/UI/Game/Dungeon/Viewport/Map/Player")
func _ready():
	p.connect("next_level", self, "update_lv")
	p.connect("player_attack", self, "update_message")
	update_lv()
	update_gold()
	update_hp()
	update_str()
	update_arm()
	update_exp()
	
func update_lv():
	lv.text = "层数：" + str(status.Level)

func update_gold():
	gold.text = "金币：" + str(status.Gold)
	
func update_hp():
	hp.text = "血量：" + str(status.HP)
	
func update_str():
	stre.text = "力量：" + str(status.Str)
	
func update_arm():
	arm.text = "护甲：" + str(status.Arm)
	
func update_exp():
	expi.text = "经验：" + str(status.Exp)

func update_message(msg):
	message.text = msg
	timer.start()

func _on_Timer_timeout():
	if not message.text.empty():
		update_message("")