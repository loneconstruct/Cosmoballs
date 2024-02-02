extends Control

onready var scoreboard = $"../.."
onready var level = int(self.name)

var chapter = 0
var record = "00:00:000"
var par : String

func timeprocess():
	
	chapter = scoreboard.get("chapter")
	par = Settings.get_par(chapter, level)
	
	var time = Settings.get_score(chapter, level)

	var ms = str(time%1000)
	for i in (3 - ms.length()):
		ms = ms.insert(0, "0")
	
	var sec = str(((time/1000)%1000)%60)
	for i in (2 - sec.length()):
		sec = sec.insert(0, "0")

	var minutes = str(((time/1000)/60)%60)
	for i in (2 - minutes.length()):
		minutes = minutes.insert(0, "0")
	
	record = minutes + ":" + sec + ":" + ms
	
	if record == "00:00:000":
		$m.text = "--"
		$s.text = "--"
		$ms.text = "---"

	else:
		$m.text = minutes
		$s.text = sec
		$ms.text = ms
		
	$mpar.text = par.substr(0, 2)
	$spar.text = par.substr(3, 2)
	$mspar.text = par.substr(6, 3)


func _ready():
	
	$Level.text = self.name
	if int(self.name) < 10:
		$Level.text = $Level.text.insert(0, "0")
		
	if int(self.name) % 2 == 0:
		$ColorRect.color = Color(0,0,0,1)
		
	timeprocess()
	
	if Settings.get_score(chapter, level) <= Settings.pars[level][1] and Settings.get_score(chapter, level) > 0:
		$Sprite.frame = 2

	else:
		$Sprite.frame = 0

func fontcolor(color : Color):
	for n in get_children():
		if n.is_class("Label"):
			n.set("custom_colors/font_color", color)

func _on_Button_mouse_entered():
	fontcolor(Color(1,1,1,1))
	if $Sprite.frame == 0:
		$Sprite.frame = 1

func _on_Button_mouse_exited():
	fontcolor(Color(1,0,0,1))
	if $Sprite.frame == 1:
		$Sprite.frame = 0
