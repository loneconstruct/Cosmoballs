extends CanvasLayer

onready var settingsbutton = get_node("Border/Settings/Highlight")
onready var mainmenubutton = get_node("Border/Main Menu/Highlight")
onready var restartbutton = get_node("Border/Restart/Highlight")
onready var levelsbutton = get_node("Border/Levels/Highlight")
onready var level = get_parent().get_node("Level " + str(get_parent().get("current_level")))
onready var Master = Settings.Master




func _ready():
	
	settingsbutton.modulate = Color(1,0,0,0.15)
	mainmenubutton.modulate = Color(1,0,0,0.15)
	restartbutton.modulate = Color(1,0,0,0.15)
	levelsbutton.modulate = Color(1,0,0,0.15)
	
	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 980)

func _process(_delta):
	if Input.is_action_just_pressed("escape") and $BorderSettings.visible == false:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Master.get_node("Unpause").call("play")
		Master.set("pause_time", OS.get_ticks_msec() - Master.get("pause_start"))
		Master.set("start_time", Master.get("start_time") + Master.get("pause_time"))
		AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 20500)
		self.queue_free()
		
	elif Input.is_action_just_pressed("escape") and $BorderSettings.visible == true:
		Master.get_node("Unpause").call("play")
		$BorderSettings.visible = false
		$BorderSettings/Settings.is_visible = false

#----- highlight restart

	if $"Border/ButtonRestart".is_hovered() == true:
		if restartbutton.modulate == Color(1,0,0,0.15):
			restartbutton.modulate = Color(1,0,0,0.5)
			$ui_hover.play()
	else:
		if restartbutton.modulate == Color(1,0,0,0.5):
			restartbutton.modulate = Color(1,0,0,0.15)
			
#----- highlight settings

	if $"Border/ButtonSettings".is_hovered() == true:
		if settingsbutton.modulate == Color(1,0,0,0.15):
			settingsbutton.modulate = Color(1,0,0,0.5)
			$ui_hover.play()
	else:
		if settingsbutton.modulate == Color(1,0,0,0.5):
			settingsbutton.modulate = Color(1,0,0,0.15)
			
#----- highlight levels

	if $"Border/ButtonLevelSelect".is_hovered() == true:
		if levelsbutton.modulate == Color(1,0,0,0.15):
			levelsbutton.modulate = Color(1,0,0,0.5)
			$ui_hover.play()
			
	else:
		if levelsbutton.modulate == Color(1,0,0,0.5):
			levelsbutton.modulate = Color(1,0,0,0.15)


#----- highlight main menu

	if $"Border/ButtonMainMenu".is_hovered() == true:
		if mainmenubutton.modulate == Color(1,0,0,0.15):
			mainmenubutton.modulate = Color(1,0,0,0.5)
			$ui_hover.play()

	else:
		if mainmenubutton.modulate == Color(1,0,0,0.5):
			mainmenubutton.modulate = Color(1,0,0,0.15)


func _on_ButtonMainMenu_pressed():
	$MouseBlock.visible = true
	$ui_select.play()
	yield(get_tree().create_timer(0.2), "timeout")
	
	Master.call("stop_timer_instant")
	Master.call("main_menu")
	var menu = Master.get_node("Main Menu")
	menu.visible = false
	menu.scale = Vector2(1,1)
	connect("tree_exited", menu, "vis")
	
	get_tree().paused = false
	
	level.queue_free()
	get_parent().get_node("Background/Planet").visible = false
	
	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 20500)
	
	queue_free()

func _on_ButtonLevelSelect_pressed():
	$MouseBlock.visible = true
	$ui_select.play()
	yield(get_tree().create_timer(0.2), "timeout")
	Master.call("stop_timer_instant")
	Master.call("main_menu", true)
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var menu = Master.get_node("Main Menu")
	menu.visible = false
	menu.scale = Vector2(1,1)
	connect("tree_exited", menu, "vis")
	
	menu.get_node("Border/Main Buttons").set("visible", false)
	menu.get_node("Border/Level Select").call("quickshow")
	$"../Background/BackgroundPlanets".scale = Vector2(1,1)

	get_tree().paused = false

	level.queue_free()
	get_parent().get_node("Background/Planet").visible = false
	
	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 20500)
	
	queue_free()


func _on_ButtonSettings_pressed():
	$ui_select.play()
	$BorderSettings.visible = true
	$BorderSettings/Settings.is_visible = true


func _on_ButtonRestart_pressed():
	$ui_select.play()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().get_node("Level " + str(get_parent().get("current_level"))).get_node("Player").call("_on_Area2D_body_entered", null)
	
	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 20500)
	
	queue_free()
