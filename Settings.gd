extends Node

onready var Master = get_tree().root.get_node_or_null("Master")

onready var current_skin = "Default"
onready var windowmode = "720p" setget setwindowsize
onready var windowscale = "720p"

onready var musicvolume : int
onready var soundvolume : int

onready var datapath = "user://save.dat"

onready var skinsounds = true

func _init():
	OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)

func _ready():
	Settings.loaddata()
	setwindowsize(windowmode)

#-------- accessible / functions --------#

func leveltotal():
	var count = 0
	for i in level_complete:
		if level_complete.get(i) == true:
			count = count + 1
	return(count)

func levelunlock():
	var count = 0
	for i in level_progress:
		if level_progress.get(i) == true:
			count = count + 1
	return(count)

func savedata():
	var data = {
		#Settings
		"ss": skinsounds,
		"sk": current_skin,
		"wm": windowmode,
		"mv": db2linear(AudioServer.get_bus_volume_db(3)),
		"sv": db2linear(AudioServer.get_bus_volume_db(1)),
		#Progress
		"lc": level_complete,
		"lv": level_progress,
		"cp": chapter_progress,
		"pp": par_progress,
		"t1": times,
		"sp": skin_unlocks
	}
	
	var file = File.new()
	var error = file.open(datapath, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
	

func loaddata():
	var file = File.new()
	if file.file_exists(datapath):
		var error = file.open(datapath, File.READ)
		if error == OK:
			
			var data = file.get_var()
			
			skinsounds = data.get("ss")
			current_skin = data.get("sk")
			windowmode = data.get("wm")
			AudioServer.set_bus_volume_db(1, linear2db(data.get("sv")))
			AudioServer.set_bus_volume_db(2, linear2db(data.get("sv")))
			AudioServer.set_bus_volume_db(3, linear2db(data.get("mv")))
			
			level_complete = data.get("lc")
			level_progress = data.get("lv")
			chapter_progress = data.get("cp")
			par_progress = data.get("pp")
			times = data.get("t1")
			skin_unlocks = data.get("sp")
			
			file.close()

#----------------------------------------#

func setwindowsize(mode):
	
	var compare = windowmode
	
	windowmode = mode
	
	match mode:
		"Fullscreen":
			OS.window_fullscreen = true	
		"1080p":
			OS.window_fullscreen = false
			OS.window_size = Vector2(1920, 1080)
		"1440p":
			OS.window_fullscreen = false
			OS.window_size = Vector2(2560, 1440)
		"2160p":
			OS.window_fullscreen = false
			OS.window_size = Vector2(3840, 2160)
		"720p":
			OS.window_fullscreen = false
			OS.window_size = Vector2(1280, 720)
	
	if windowmode != compare:

		OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)

func record_score(_chapter, level, time):

	var partotal = 0
	
	if times[level] > time or times[level] == 0:
		times[level] = time
	
	for i in 25:
		if times[i + 1] > 0 and times[i + 1] <= pars[i + 1][1]:
			partotal += 1
		if i == 24:
			par_progress = partotal
			
			savedata()

func get_score(_chapter, level):
			return times[level]

func get_par(_chapter, level):
	return pars[level][0]

#-------- internal variables --------#

# total level progress in chapters
var chapter_progress = {
	1: 1,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0
	} # 26 means last level completed

var level_progress = {
	1:true,
	2:false,
	3:false,
	4:false,
	5:false,
	6:false,
	7:false,
	8:false,
	9:false,
	10:false,
	11:false,
	12:false,
	13:false,
	14:false,
	15:false,
	16:false,
	17:false,
	18:false,
	19:false,
	20:false,
	21:false,
	22:false,
	23:false,
	24:false,
	25:false
	}
	
var level_complete = {
	1:false,
	2:false,
	3:false,
	4:false,
	5:false,
	6:false,
	7:false,
	8:false,
	9:false,
	10:false,
	11:false,
	12:false,
	13:false,
	14:false,
	15:false,
	16:false,
	17:false,
	18:false,
	19:false,
	20:false,
	21:false,
	22:false,
	23:false,
	24:false,
	25:false
	}

var par_progress = 0

const music = {
	1:"Tutorial",
	2:"Zone1",
	3:"Zone1",
	4:"Zone1",
	5:"BossMusic",
	6:"Zone2",
	7:"Zone2",
	8:"Zone2",
	9:"Dark",
	10:"BossMusic",
	11:"Tutorial",
	12:"Zone3",
	13:"Zone3",
	14:"Zone3",
	15:"BossMusic",
	16:"Zone2",
	17:"Zone2",
	18:"Zone2",
	19:"Dark",
	20:"BossMusic",
	21:"Zone1",
	22:"Zone1",
	23:"Zone1",
	24:"Zone1",
	25:"BossMusic"
	}

var pars : Dictionary = {
	1: ["00:24:000", 24000],
	2: ["00:09:500", 9500],
	3: ["00:27:500", 27500],
	4: ["00:16:000", 16000],
	5: ["00:23:000", 23000],
	6: ["00:18:000", 18000],
	7: ["00:14:500", 14500],
	8: ["01:12:000", 72000],
	9: ["00:45:000", 45000],
	10: ["00:48:000", 48000],
	11: ["00:21:000", 21000],
	12: ["00:18:000", 18000],
	13: ["00:26:000", 26000],
	14: ["00:58:000", 58000],
	15: ["00:24:000", 24000],
	16: ["00:16:500", 16500],
	17: ["00:45:000", 45000],
	18: ["00:57:500", 57500],
	19: ["00:58:000", 58000],
	20: ["00:55:000", 55000],
	21: ["00:30:000", 30000],
	22: ["00:22:000", 22000],
	23: ["00:20:000", 20000],
	24: ["00:24:000", 24000],
	25: ["01:00:000", 60000]
	}

var times : Dictionary = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0,
	7: 0,
	8: 0,
	9: 0,
	10: 0,
	11: 0,
	12: 0,
	13: 0,
	14: 0,
	15: 0,
	16: 0,
	17: 0,
	18: 0,
	19: 0,
	20: 0,
	21: 0,
	22: 0,
	23: 0,
	24: 0,
	25: 0
	}

var levelnames : Dictionary = {
	1:"Tutorial 1",
	2:"UFO",
	3:"Quadrilateral",
	4:"Zero Crossing",
	5:"Reactor",
	6:"Corridor",
	7:"Silo",
	8:"Chambered",
	9:"The Heart",
	10:"Super Reactor",
	11:"Tutorial 2",
	12:"Conveyor",
	13:"Battlements",
	14:"Matrix",
	15:"Ring of Death",
	16:"Energy Transfer",
	17:"Synapse",
	18:"Tunneler",
	19:"Astroid Mine",
	20:"Research Station",
	21:"Corvette",
	22:"Gridlock",
	23:"Switchback",
	24:"Derelict",
	25:"The Gauntlet"
	}

var skin_unlocks = {
	"Default": true,
	"Ghost": false,
	"Terminal": false,
	"Mystery Crystal": false,
	"Hypnotic": false,
	"Be the Block": false,
	"Rainbow Splatter": false,
	"Handheld": false,
	"Tech Cube": false,
	"Construct": false,
	"Eldritch": false,
	"Lucky": false,
	"Bento": false,
#	"Missing Texture": true,
#	"Iron Plated": true,
	}

#----------------------------------------

