extends NinePatchRect

var chapter = 1
onready var skinselect = get_node("../../Skin Select")

func ready():
	$Left.connect("pressed", self, "select", ["Left"])
	$Right.connect("pressed", self, "select", ["Right"])
	$Label.text = "Chapter 1"
	update_count()

func label():
	if chapter > 6:
		chapter = 1
	elif chapter < 1:
		chapter = 6
		
	skinselect.get_node("Chapter " + str(chapter)).visible = true
	$Label.text = "Chapter " + str(chapter)
	
	update_count()
	
func _on_Left_pressed():
	$"../../../ui_select".play()
	skinselect.get_node("Chapter " + str(chapter)).visible = false
	chapter -= 1
	label()

func _on_Right_pressed():
	$"../../../ui_select".play()
	skinselect.get_node("Chapter " + str(chapter)).visible = false
	chapter += 1
	label()

func update_count():
	var count = 0
	var total = skinselect.get_node("Chapter " + str(chapter)).get_child_count()
	
	for node in skinselect.get_node("Chapter " + str(chapter)).get_children():
		if node.disabled == false:
			count += 1
			
	$"../Count".text = str(count)
	$"../Total".text = str(total)
