extends TextureButton

onready var Highlight = get_node("Highlight")

onready var red = preload("res://GUI/soundbutton1.png")
onready var green = preload("res://GUI/soundbutton2.png")

func on():
	self.texture_normal = green
	$green.visible = true
	$red.visible = false
	
func off():
	self.texture_normal = red
	$red.visible = true
	$green.visible = false

func _ready():
	
	self.connect("pressed", self, "input_event")
	
	if Settings.skinsounds == true:
		on()
	else:
		off()

func input_event():

	if Settings.skinsounds == false:
		
		Settings.skinsounds = true
		on()
		$"../../../ui_select".play()
		
	else:
		
		Settings.skinsounds = false
		off()
		$"../../../ui_select".play()
	
	$"../SkinDemo".initiate()

func _process(_delta):
	
	if is_hovered() == true:
		
		if Settings.skinsounds == false:
			if Highlight.modulate != Color(1,0,0,1):
				Highlight.modulate = Color(1,0,0,1)
				$"../../../ui_hover".play()
	
		else:
			if Highlight.modulate != Color(0,1,0,0.5):
				Highlight.modulate = Color(0,1,0,0.5)
				$"../../../ui_hover".play()
				
		if $"../soundmsg".visible == false:
			$"../SkinName".visible = false
			$"../soundmsg".visible = true
		
	else:
	
		if Settings.skinsounds == false:
			if Highlight.modulate != Color(1,0,0,0.15):
				Highlight.modulate = Color(1,0,0,0.15)
	
		else:
			if Highlight.modulate != Color(0,1,0,0.15):
				Highlight.modulate = Color(0,1,0,0.15)
				
		if $"../soundmsg".visible == true:
			$"../SkinName".visible = true
			$"../soundmsg".visible = false
