extends Node2D

onready var Master = Settings.Master
onready var Wipe = $Border/WipeEffect/AnimationPlayer

var button
var canreturn = true

onready var back = Master.get_node("back")

var confirm = false

#--------------------------------------

func _init():
	scale = Vector2(0,0)

func zoom():
	$"../Background/BackgroundGradient".modulate = Color(1,1,1,0)
	$"../Background/BackgroundPlanets".scale = Vector2(0,0)
	$PlaneControl.play("Zoom")
	$"../Background/Transition".play("default")
	yield($PlaneControl, "animation_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func vis():
	
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func ui_press(button_name):

	button = button_name

	if button as int >= 1 and button as int <= 30:
		$ui_select.play()
		Master.set("current_level", button as int)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$PlaneControl.play("fadewhite")
		$game_start.play()

	else:

		match button:
			"Level Select":
				$"Border/Main Buttons".visible = false
				$"Border/Chapter Select".is_visible = true
			"Customize":
#				$PlaneControl.play("skin_chapter")
				$"Border/Main Buttons".visible = false
				$"Border/Skin Select".is_visible = true
				for node in $"Border/Skin Select".get_children():
					if "Chapter" in node.name:
						node.visible = false
				$"Border/SkinChapterPosition/ChapterSelection".chapter = 1
				$"Border/SkinChapterPosition/ChapterSelection".call("label")
				$"Border/Skin Select".check()
			"Scoreboard":
				$"Border/Main Buttons".visible = false
				$"Border/Scoreboard".is_visible = true
#				$"Border/Scoreboard".set("can_return", true)
#				$"Border/MouseBlock".visible = false
			"Settings":
				$"Border/Main Buttons".visible = false
				$"Border/Settings".is_visible = true
				$"Border/Settings".set("can_return", true)
				$"Border/MouseBlock".visible = false
			"Quit Game":
				
				if confirm == false:
					confirm = true
					$"Border/Main Buttons/Quit Game/Label".text = "really quit?"
					$"Border/MouseBlock".visible = false
				else:
					
					$"Border/Main Buttons/Quit Game/Label".text = "bye!"
					
					get_tree().get_root().set_disable_input(true)
					
					Settings.savedata()
					
					$PlaneControl.play("fadeblack")
					$game_quit.play()

#--------------------------------------
func _on_PlaneControl_animation_finished(anim_name):
	match anim_name:
		"fadewhite":
			get_tree().get_root().set_disable_input(false)
			Master.call("begin")
		"fadeblack":
			get_tree().quit()

#--------------------------------------

func WipeEffect(name):
	
	if name != "Quit Game":
		$"Border/MouseBlock".visible = true
		$ui_select.play()
		yield(get_tree().create_timer(0.1), "timeout")
		$wipe.play()
		Wipe.play("Wipe")
		yield(Wipe, "animation_finished")
		Wipe.play("RESET")
		ui_press(name)
		
	else:
		$ui_select.play()
		ui_press(name)

func _process(_delta):
	if self.visible and !$"Border/Main Buttons".visible:
		if !back.visible:
			back.visible = true
	else:
		if back.visible:
			back.visible = false


func _on_Main_Menu_tree_exited():
	back.visible = false
