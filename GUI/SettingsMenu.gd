extends VBoxContainer

onready var Wipe
onready var can_return = false

onready var Fullscreen = get_node("HBoxFullscreen/Fullscreen")
onready var W1080 = get_node("Resolutions1/1080p")
onready var W1440 = get_node("Resolutions2/1440p")
onready var W2160 = get_node("Resolutions2/2160p")
onready var W720 = get_node("Resolutions1/720p")


onready var is_visible = false setget showcontainer

func _ready():
	
	if get_node_or_null("../WipeEffect/AnimationPlayer") != null:
		Wipe = get_node("../WipeEffect/AnimationPlayer")

	$"HBoxMusic/Music".value = db2linear(AudioServer.get_bus_volume_db(3))
	
	$"HBoxSound/Sound".value = db2linear(AudioServer.get_bus_volume_db(1))
	

	Fullscreen.connect("pressed", self, "WindowToggle", ["Fullscreen"])
	W1080.connect("pressed", self, "WindowToggle", ["1080p"])
	W1440.connect("pressed", self, "WindowToggle", ["1440p"])
	W2160.connect("pressed", self, "WindowToggle", ["2160p"])
	W720.connect("pressed", self, "WindowToggle", ["720p"])


func showcontainer(state):
	
	self.visible = state
	
	if state == true:
		WindowToggle(Settings.windowmode)

func WindowToggle(state):
	
	var sh = state
	sh.erase(sh.length() - 1, 1)
	
	if OS.get_screen_size().y <= int(sh):
		state = "Fullscreen"

	match state:
		"Fullscreen":
			
			Settings.windowmode = "Fullscreen"
			
			Fullscreen.pressed = true
			W720.pressed = false
			W2160.pressed = false
			W1080.pressed = false
			W1440.pressed = false
	
		"720p":
			
			
			Settings.windowmode = "720p"
			Settings.windowscale = "720p"
			
			Fullscreen.pressed = false
			W720.pressed = true
			W2160.pressed = false
			W1080.pressed = false
			W1440.pressed = false		

		"2160p":
			
			Settings.windowmode = "2160p"
			Settings.windowscale = "2160p"
			
			Fullscreen.pressed = false
			W720.pressed = false
			W2160.pressed = true
			W1080.pressed = false
			W1440.pressed = false
			
		"1080p":
			
			Settings.windowmode = "1080p"
			Settings.windowscale = "1080p"
			
			Fullscreen.pressed = false
			W720.pressed = false
			W2160.pressed = false
			W1080.pressed = true
			W1440.pressed = false
			

		"1440p":
			
			Settings.windowmode = "1440p"
			Settings.windowscale = "1440p"
			
			Fullscreen.pressed = false
			W720.pressed = false
			W2160.pressed = false
			W1080.pressed = false
			W1440.pressed = true
	

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(3, linear2db(value))
	Settings.musicvolume = value

func _on_Sound_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))
	AudioServer.set_bus_volume_db(2, linear2db(value))
	Settings.soundvolume = value

func _process(_delta):
	if Input.is_action_just_pressed("escape") and can_return == true:
			
			can_return = false
			$"../MouseBlock".visible = true
			
			Settings.savedata()
			
			$"../../ui_back".play()
			Wipe.play("Wipe")
			yield(Wipe, "animation_finished")
			Wipe.play("RESET")
			self.visible = false
			get_parent().get_node("Main Buttons").visible = true
			$"../MouseBlock".visible = false
