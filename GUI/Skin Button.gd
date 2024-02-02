extends TextureButton

onready var skin = self.name
onready var Highlight = get_node("Highlight")
var selected = false
var playerAnim : AnimationPlayer 

func _ready():

	self.connect("pressed", self, "input_event")
	
	$Sprite.texture = load("res://Player/Skins/" + skin + ".png")
	
	if skin == "Lucky":
		$Sprite.hframes = 6
		$Sprite.frame = 5


func input_event():
	
	if self.disabled == false and selected == false:
		$"../../../../skin_select".play()
		Settings.current_skin = skin
		$"../../SkinName".text = skin
		Highlight.modulate = Color(1,1,0,1)
		get_node("../..").check()

func _process(_delta):
	if is_hovered() == true and selected == false and disabled == false:
		if Highlight.modulate == Color(1,0,0,0.15):
			Highlight.modulate = Color(1,0,0,1)
			$"../../../../ui_hover".play()
	elif is_hovered() == false and selected == false:
		if Highlight.modulate == Color(1,0,0,1):
			Highlight.modulate = Color(1,0,0,0.15)
