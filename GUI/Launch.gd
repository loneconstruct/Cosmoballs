extends TextureButton

func _ready():
	$Highlight.modulate = Color(1,0,0,0.15)

func _process(_delta):
	if is_hovered() == true:
		if $Highlight.modulate == Color(1,0,0,0.15):
			$Highlight.modulate = Color(1,0,0,0.3)
			$"../../../../ui_hover".play()
	elif is_hovered() == false:
		if $Highlight.modulate == Color(1,0,0,0.3):
			$Highlight.modulate = Color(1,0,0,0.15)
