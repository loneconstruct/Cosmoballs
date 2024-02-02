extends CanvasLayer

onready var border = get_node("Position2D/Container/Border")
onready var label = get_node("Position2D/Container/Label")


func message(text):
	
	label.text = text
	
	yield(get_tree().create_timer(0.1),"timeout")

	border.anchor_left = -0.5
	border.anchor_top = -0.15
	border.anchor_right = 0.5
	border.anchor_bottom = 0.15
	
	$AnimationPlayer.play("popup")
