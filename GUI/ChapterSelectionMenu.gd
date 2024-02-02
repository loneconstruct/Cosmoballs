extends Position2D

onready var ChapterSelect = get_node("../Chapter Select")
onready var Master = Settings.Master

var chapter = 1




func update():
	$"../../ui_select".play()
	$Chapters/Label.text = "Chapter " + str(chapter)
	Master.current_chapter = chapter

func _on_Left_pressed():
	chapter -= 1
	if chapter < 1:
		chapter = 6
	update()

func _on_Right_pressed():
	chapter += 1
	if chapter > 6:
		chapter = 1
	update()


func _on_Launch_pressed():
	$"../MouseBlock".visible = true
	$"../../ui_select".play()
	ChapterSelect.levelselect()
