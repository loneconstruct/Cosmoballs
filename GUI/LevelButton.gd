extends TextureButton

onready var number = str(self.name)
onready var is_disabled : bool setget state

onready var nospacing =  load("res://GUI/LevelButtonFont_Alt.tres")

onready var MainMenu = get_node("../../..")
onready var Highlight = get_node("Highlight")

onready var LevelMenu = get_node("../")

onready var text = $Panel/Text

onready var count = Settings.leveltotal()

func _ready():
	

	self.modulate = Color(1,1,1,0)
	$Label.visible = !is_disabled
	self.connect("pressed", self, "input_event")
	self.connect("mouse_entered", self, "update_value")

	$Label.text = number
	if int(number) > 19:
		$Label.add_font_override("font", nospacing)

func input_event():
	
	if is_disabled == false:
		MainMenu.call("ui_press", number)
		get_tree().get_root().set_disable_input(true)
		MainMenu.get_node("Border/Level Select").can_return = false
		
func state(state : bool):
	self.disabled = state
	$Label.visible = !state

func lcount(value):
	if value == 1:
		return (" ")
	else:
		return ("s ")

func hoverText():
	
	if !$Panel.visible:
		var num = int(self.name)
		
		var diff = num - count - 1
		
		if num == 1 or num == 11:
			pass
		
		elif num < 10 and num % 5 != 0:
			text.text = "complete level 1 to unlock"
		
		elif num > 11 and num % 5 != 0:
			text.text = "complete level 11 to unlock"
		
		else:
			text.text = "complete " + str(diff) + " more level" + lcount(diff) + "to unlock"
		
		$Panel.visible = true




func _process(_delta):
	
	if is_hovered() == true and disabled == false:
		if Highlight.modulate == Color(1,0,0,0.15):
			Highlight.modulate = Color(1,0,0,1)
			$"../../../ui_hover".play()
	else:
		if Highlight.modulate == Color(1,0,0,1):
			Highlight.modulate = Color(1,0,0,0.15)


func update_value():
	if LevelMenu.get("hovered") != number:
		LevelMenu.set("hovered", number)


func _on_mouse_entered():
	if disabled and !$Panel.visible:
		hoverText()


func _on_mouse_exited():
	if disabled and $Panel.visible:
		$Panel.visible = false
