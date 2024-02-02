extends NinePatchRect

onready var ball = get_node("ChapterInfo/HazardBox/Ball")
onready var ballinfo = get_node("ChapterInfo/Ball Info")
onready var chapterinfo = get_node("../../LaunchPosition/InfoBox/Chapter Info")

var red = Color(1, 0, 0)
var blue = Color(0,0.56,1)
var green = Color(0.246542, 0.774414, 0)
var yellow = Color(0.951172, 1, 0)
var frost = Color(0.461331, 0.977906, 1)
var midnight = Color(0.08723, 0.128234, 1)

var skinprog
var check

var percentage

func update_chapter(chapter : int):
#	match chapter:
#		1: 
#			ball.modulate = red
#			ballinfo.bbcode_text = \
#			"[center][color=#" + red.to_html() + "]RED[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]STABLE AND\n" +\
#			"PREDICTABLE"
#
#		2: 
#			ball.modulate = blue
#			ballinfo.bbcode_text = \
#			"[center][color=#" + blue.to_html() + "]BLUE[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]DANGEROUS\n" +\
#			"UNDERWATER"
#
#		3: 
#			ball.modulate = green
#			ballinfo.bbcode_text = \
#			"[center][color=#" + green.to_html() + "]GREEN[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]ADAPTIVE TO\n" +\
#			"ENVIRONMENT"
#		4: 
#			ball.modulate = yellow
#			ballinfo.bbcode_text = \
#			"[center][color=#" + yellow.to_html() + "]YELLOW[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]EXTREMELY\n" +\
#			"UNSTABLE"
#		5: 
#			ball.modulate = frost
#			ballinfo.bbcode_text = \
#			"[center][color=#" + frost.to_html() + "]CYAN[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]COLLECTIVE\n" +\
#			"INTELLIGENCE"
#
#		6: 
#			ball.modulate = midnight
#			ballinfo.bbcode_text = \
#			"[center][color=#" + midnight.to_html() + "]DARK[/color]\n" +\
#			"------------\n" +\
#			"[color=yellow]EXCEEDINGLY\n" +\
#			"ANOMALOUS"
	
	# check specific range of skin list for chapter-specific skin unlocks
	
	skinprog = 0
	check = 0

	for i in Settings.skin_unlocks:
		
		check += 1
		
		if Settings.skin_unlocks[i] == true and check > 1:
			skinprog += 1

		if check == 13:
			break
	
	# --------------------------------------------------------------------
	percentage = round((((float(Settings.leveltotal())) / 25.0) * 37.5) + ((float(Settings.par_progress) / 25.0) * 37.5) + ((skinprog / 12.0) * 25.0))

	chapterinfo.bbcode_text = \
	"[center][color=#" + yellow.to_html() + "]CHAPTER " + str(chapter) + "[/color]\n" +\
	"------------------[/center]\n" +\
	"COMPLETE : [color=yellow]" + str(Settings.leveltotal()) + " / 25  [/color]\n" +\
	"[center]------------------[/center]\n" +\
	"PAR TIMES : [color=yellow]" + str(Settings.par_progress) + "/ 25 [/color]\n" +\
	"[center]------------------[/center]\n" +\
	"SECRETS : [color=yellow]" + str(skinprog) + " / 12 [/color]\n" +\
	"[center]------------------[/center]\n" +\
	"OVERALL : [color=yellow]" + str(percentage) + "%" 
	
	if (Settings.chapter_progress.get(chapter) - 1) == 25:
		chapterinfo.bbcode_text = chapterinfo.bbcode_text.replace("COMPLETE : [color=yellow]", "COMPLETE : [color=lime]")

	if Settings.par_progress == 25:
		chapterinfo.bbcode_text = chapterinfo.bbcode_text.replace("PAR TIMES : [color=yellow]", "PAR TIMES : [color=lime]")

	if skinprog == 12:
		chapterinfo.bbcode_text = chapterinfo.bbcode_text.replace("SECRETS : [color=yellow]", "SECRETS : [color=lime]")
	
	if percentage == 100:
		chapterinfo.bbcode_text = chapterinfo.bbcode_text.replace("OVERALL : [color=yellow]", "OVERALL : [color=lime]")
