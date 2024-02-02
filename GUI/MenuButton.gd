extends TextureButton

onready var MainMenu = get_node("../../..")
var highlighted = false

func _ready():
	self.connect("pressed", MainMenu, "WipeEffect", [self.name])
	self.connect("pressed", self, "highlight")
	$Highlight.modulate = Color(1,0,0,0.15)
	
func _process(_delta):
	if (is_hovered() == true or highlighted == true) and Input.mouse_mode == 0:
		if $Highlight.modulate == Color(1,0,0,0.15):
			$Highlight.modulate = Color(1,0,0,0.3)
			$"../../../ui_hover".play()
		
		elif self.name != "Quit Game":
			MainMenu.confirm = false
			$"../Quit Game/Label".text = "Quit Game"
		
	elif is_hovered() == false:
	
		if $Highlight.modulate == Color(1,0,0,0.3):
			$Highlight.modulate = Color(1,0,0,0.15)
		
		if self.name == "Quit Game":
			
			$Label.text = "Quit Game"
			MainMenu.confirm = false

func highlight():
	if self.name == "Quit Game":
		pass
	else:
		highlighted = true
		yield($"../../WipeEffect/AnimationPlayer", "animation_finished")
		highlighted = false
