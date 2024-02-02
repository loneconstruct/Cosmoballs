extends Node2D

# clicking blocked chapters makes buzz noise
# add note to skin section saying skins do not change gameplay
# add medals to level select to indicate completion / par reached

#_______________________________________________________
# songs to add
# -> MAIN THEME ✓
# -> TUTORIAL ✓
# -> AREA 1 ✓
# -> AREA 2 ✓
# -> AREA 3 
# -> AREA 4 
# -> HARD LEVEL ✓
# -> BOSS LEVEL 
# -> STASIS (LEVEL 25) 
# -> YOU DID IT! 

#_______________________________________________________

var skippable = false

onready var Music = $Music

onready var current_chapter = 1
onready var current_level = 1

onready var MainMenu = preload("res://GUI/Main Menu.tscn")
onready var PauseMenu = preload("res://GUI/PauseMenu.tscn")

var start_time = 0
var time = 0
var final_time = 0
var counting = false
var tweening = false
var pause_start = 0
var pause_time = 0


onready var timelabel = $"TimerBox/PositionTimer/Border/Label"

#__________music________________________________________

onready var MainTheme = preload("res://Music/MainTheme.wav")
onready var Tutorial = preload("res://Music/Tutorial.wav")
onready var BossMusic = preload("res://Music/BossMusic.wav")
onready var Dark = preload("res://Music/Dark.wav")
onready var Zone1 = preload("res://Music/zone1.wav")
onready var Zone2 = preload("res://Music/zone2.wav")
onready var Zone3 = preload("res://Music/zone3.wav")

#_______________________________________________________

func set_skin(skin):
	Settings.current_skin = skin

#_______________________________________________________

func setskippable(state : bool):
	skippable = state
	$skip.visible = state


func _ready():
	
	OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	#yield(get_tree().create_timer(1.5),"timeout")
	
	$SplashScreen/AnimationPlayer.play("splash")
	Music.play()

	yield($SplashScreen/AnimationPlayer, "animation_finished")
	
	
	
	skippable = false
	$SplashScreen/splash2.stop()
	$SplashScreen/splash.stop()
	$SplashScreen.queue_free()
	main_menu()
	$"Main Menu".call("zoom")

#_______________________________________________________

func timeprocess():

	var ms = str(time%1000)
	for i in (3 - ms.length()):
		ms = ms.insert(0, "0")
	
	var sec = str(((time/1000)%1000)%60)
	for i in (2 - sec.length()):
		sec = sec.insert(0, "0")

	var minutes = str(((time/1000)/60)%60)
	for i in (2 - minutes.length()):
		minutes = minutes.insert(0, "0")
	
	timelabel.text = minutes + ":" + sec + ":" + ms

#_______________________________________________________

func _process(_delta):
	
	if Input.is_action_just_pressed("interact") and skippable == true:
		skippable = false
		$skip.visible = false
		
		Music.seek(6.75)
		$SplashScreen/AnimationPlayer.emit_signal("animation_finished")
		
	
	if counting and get_tree().paused == false:
		
		time = OS.get_ticks_msec() - start_time
		timeprocess()

	elif tweening:
		
		time = int(round(time))
		timeprocess()

	#_______________________________________________________

	if Input.is_action_just_pressed("toggle_fullscreen"):

		if Settings.windowmode != "Fullscreen":
			Settings.windowmode = "Fullscreen"

		else:
			Settings.windowmode = Settings.windowscale

		if get_node_or_null("Main Menu") != null:
			$"Main Menu/Border/Settings".call("WindowToggle", Settings.windowmode)
		
		elif get_node_or_null("PauseMenu") != null:
			$"PauseMenu/BorderSettings/Settings".call("WindowToggle", Settings.windowmode)
			

#_______________________________________________________

func main_menu(pauseLevelSelect = false):
	
	self.add_child(MainMenu.instance())
	
	if pauseLevelSelect == false:
		if Music.stream != MainTheme:
			Music.stream = MainTheme
			Music.play()

	$MessageBox/AnimationPlayer.play("RESET")
	$TimerBox/AnimationPlayer.play("RESET")
	$Background.menu()

func pause_menu():
	$Pause.play()
	self.add_child(PauseMenu.instance())
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pause_start = OS.get_ticks_msec()
	get_tree().paused = true
	


func begin():
	$"Main Menu".queue_free()
	start_stage()

func start_stage():
	
	var level = load("res://Chapter "+str(current_chapter)+"/Level "+str(current_level)+".tscn")
	
	self.add_child(level.instance())
	
	var track = Settings.music[current_level]
	if (Music.stream != self.get(track)):
		if track != "":
			Music.stream = self.get(track)
			Music.play()
		else:
			Music.stream = null
	
	$Background.level()
	#--------------------------------
	
	AudioServer.set_bus_mute(1, false)
	$"Level Enter".play()

	var levelnumber = "Sector " + str(current_level)
	$MessageBox.message(levelnumber + " - " + Settings.get("levelnames").get(current_level))
	
	$TimerBox/AnimationPlayer.play("show")
	timelabel.text = "00:00:000"

func advance_stage():
	
	#### check all the level completion shit ####################
	
	if current_level == 1 and Settings.level_complete[1] == false:
		for i in 10:
			Settings.level_progress[i+2] = true
			

		Settings.level_progress[5] = false
		Settings.level_progress[10] = false
			
	if current_level == 11 and Settings.level_complete[11] == false:

		for i in 13:
			Settings.level_progress[i+12] = true
			
		Settings.level_progress[15] = false
		Settings.level_progress[20] = false
	
	Settings.level_complete[current_level] = true
	
	if Settings.leveltotal() >= 4 and Settings.level_progress[5] == false:
		Settings.level_progress[5] = true
	
	if Settings.leveltotal() >= 9 and Settings.level_progress[10] == false:
		Settings.level_progress[10] = true
	
	if Settings.leveltotal() >= 14 and Settings.level_progress[15] == false:
		Settings.level_progress[15] = true

	if Settings.leveltotal() >= 19 and Settings.level_progress[20] == false:
		Settings.level_progress[20] = true	

	if Settings.leveltotal() >= 24 and Settings.level_progress[25] == false:
		Settings.level_progress[25] = true
	
	############################################################
	
	if Settings.level_complete[current_level] == false:
		Settings.level_complete[current_level] = true
	
	Settings.savedata()
	
	############################################################

	if current_level == 25:
		chapter_complete()
	
	else:
		current_level += 1
		
		if Settings.level_complete[current_level] == true:
			backToLevels()
		
		elif Settings.level_progress[current_level] == true:
			start_stage()
		
		else:
			backToLevels()


func backToLevels():
	
	self.add_child(MainMenu.instance())
	
	var menu = $"Main Menu"
	var anim : AnimationPlayer = menu.get_node("PlaneControl")
	var sound : AudioStreamPlayer = menu.get_node("ui_back")
	
	sound.pitch_scale = 0.28
	menu.get_node("Border/MouseBlock").visible = true
	menu.visible = false
	menu.scale = Vector2(1,1)
	menu.get_node("Border/Main Buttons").set("visible", false)
	menu.get_node("Border/Level Select").call("quickshow")
	
	$Background/Planet.visible = false
	$Background/BackgroundPlanets.visible = true
	$Background/BackgroundPlanets.scale = Vector2(1,1)
	

	
	menu.vis()
	
	sound.play()
	anim.play("fadeinwhite")
	yield(anim, "animation_finished")
	
	sound.stop()
	sound.pitch_scale = 1
	
	
#	menu = Master.get_node("Main Menu")
#	menu.visible = false
#	menu.scale = Vector2(1,1)
#	connect("tree_exited", menu, "vis")
#
#	menu.get_node("Border/Main Buttons").set("visible", false)
#	menu.get_node("Border/Level Select").call("quickshow")
#	$"../Background/BackgroundPlanets".scale = Vector2(1,1)
#
#	get_tree().paused = false
#
#	level.queue_free()
#	get_parent().get_node("Background/Planet").visible = false
#
#	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", 20500)
#
#	queue_free()


func chapter_complete():
	$Background/Planet.visible = false
	$win.call("show")
	Music.stream = MainTheme
	
	Music.play()
	Music.seek(6.75)
	

func start_timer():
	
	start_time = OS.get_ticks_msec()
	
	counting = true
	
func stop_timer(levelcompleted : bool):
	
	counting = false
	
	if levelcompleted == true:
		final_time = time
		Settings.record_score(current_chapter, current_level, final_time)
		$TimerBox/AnimationPlayer.play("hide")

	else:
		$Tween.interpolate_property(self, "time", time, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.start()
		tweening = true
		yield($Tween, "tween_completed")
		tweening = false

func stop_timer_instant():
	counting = false
	timelabel.text = "00:00:000"




