extends GridContainer

onready var Master = Settings.Master
onready var is_visible : bool setget showcontainer
onready var MouseBlock = $"../MouseBlock"
onready var Wipe = $"../WipeEffect/AnimationPlayer"
var can_return = false
onready var rng = RandomNumberGenerator.new()

onready var textbox = $"../LevelInfoPosition/InfoBox/Control/Level Info"
onready var parbox = $"../LevelInfoPosition/InfoBox/Control/Par"
onready var bestbox = $"../LevelInfoPosition/InfoBox/Control/Best"

onready var hovered = "1" setget update_hovered, get_number
onready var texture = $"../LevelInfoPosition/InfoBox/Control/TextureRect"
onready var Dummy = preload("res://GUI/Dummy.tscn")

onready var Tiles = get_parent().get_node("Tiles")

var ch = 1

func get_number():
	return(hovered)

func timeprocess(time):
	
	var ms = str(time%1000)
	for i in (3 - ms.length()):
		ms = ms.insert(0, "0")
	
	var sec = str(((time/1000)%1000)%60)
	for i in (2 - sec.length()):
		sec = sec.insert(0, "0")

	var minutes = str(((time/1000)/60)%60)
	for i in (2 - minutes.length()):
		minutes = minutes.insert(0, "0")
	
	var convertedTime = minutes + ":" + sec + ":" + ms
	
	if convertedTime == "00:00:000":
		convertedTime = "--:--:---"
	
	return convertedTime

func update_hovered(value : String):
	hovered = value

	texture.texture = load("res://ThumbnailCache/Chapter" + str(Master.get("current_chapter")) + "Level" + value + ".png")
	
	if get_node(value).disabled == true:
		textbox.bbcode_text = "[center]" + "???????"
	
		parbox.bbcode_text = "[center]" + "PAR --:--:---"
		
		bestbox.bbcode_text = "[center]" + "BEST " + timeprocess(Settings.get("times")[int(hovered)])
		
	else:
		textbox.bbcode_text = "[center]" + Settings.levelnames.get(int(value))
		
		parbox.bbcode_text = "[center]" + "PAR " + Settings.get_par(ch, int(value))
		
		bestbox.bbcode_text = "[center]" + "BEST " + timeprocess(Settings.get("times")[int(hovered)])
	
func _process(_delta):

	if Input.is_action_just_pressed("escape") and can_return == true:
		
#		$"../Dim".visible = true
#		$"../../noise".play()

		can_return = false
		MouseBlock.visible = true
		$"../../ui_select".play()
		
		tileShow(true)

		$"../../PlaneControl".play_backwards("level_info")

		$"../../computerbeeps".stop()
		$"../../computerbeeps".pitch_scale = 1

		var buttonarray = []
		
		var button 
		
		for i in 25:
			
			buttonarray.append(i+1)
			
			button = get_child(i)
			button.modulate = Color("#bfbfbf")
			button.release_focus()
			
		var count = 0
		
		$"../../ui_hover".pitch_scale = 1.2
		
		for i in 25:
			
			$"../../ui_hover".play()

			count += 1
			var index
			var value
			index = rng.randi_range(0, 25 - count)
			value = buttonarray[index]
			buttonarray.remove(index)

			var node = get_node(str(value))

			node.modulate = Color(1,1,1,0)
			yield(get_tree().create_timer(0.02), "timeout")

			if count == 25:
				
				
#				$"../../noise".stop()

				$"../Background/AnimationPlayer".play_backwards("FadeIn")

				$"../../ui_back".play()
				Wipe.play("Wipe")
				yield(Wipe, "animation_finished")
				Wipe.play("RESET")

				showcontainer(false)
				get_parent().get_node("Main Buttons").visible = true
				

#---------------------------------------------------

func quickshow():
	
	Tiles.visible = true
	
	can_return = false
	MouseBlock.visible = true

	update_hovered("1")
	
	self.visible = true
	$"../LevelInfoPosition".visible = true
	$"../LevelInfoPosition".position = Vector2(7,10)
	$"../Background".visible = true
	$"../Background".modulate = Color(1,1,1,1)
	
	tileShow()

	#var number = Settings.chapter_progress[1]

	for i in 25:

		var node = get_node(str(i + 1))
		
		if !Settings.level_progress[int(node.name)]:
			node.is_disabled = true
			node.get_node("Highlight").visible = false
		else:
			node.is_disabled = false
			checkState(node)

		node.modulate = Color("#bfbfbf")

		if i == 24:
			

			$"../../ui_hover".pitch_scale = 1
			
			can_return = true
			MouseBlock.visible = false

			for j in 25:
				get_child(j).modulate = Color("#ffffff")

func tileShow(hide = false):
	
	var r1 = Tiles.get_node("Row1")
	var r2 = Tiles.get_node("Row2")
	var r3 = Tiles.get_node("Row3")
	var r3a = Tiles.get_node("Row3Alt")
	var r4 = Tiles.get_node("Row4")
	var r5 = Tiles.get_node("Row5")	
	
	if hide == false:
	
		var number = Settings.levelunlock()
		
		if number > 11:
			pass
		
		elif number == 1:
			r1.visible = true
			r2.visible = true
			r3.visible = true
			r4.visible = true
			r5.visible = true
		
		else:
			r3a.visible = true	
			r4.visible = true
			r5.visible = true
			
	else:
		r1.visible = false
		r2.visible = false
		r3.visible = false
		r3a.visible = false
		r4.visible = false
		r5.visible = false

func checkState(node):
	var num = int(node.name)
	
	if Settings.level_complete[num]:
		node.get_node("Complete").visible = true

	if Settings.get_score(1, num) <= Settings.pars[num][1] and Settings.get_score(1, num) > 0:
		node.get_node("Par").visible = true
		

func showcontainer(state : bool):
	
	Tiles.visible = state
	
	
	self.visible = state
	$"../LevelInfoPosition".visible = state
	$"../Background".visible = state

	if state == false:
#		$"../Dim".visible = false

		$"../../computerbeeps".stop()
		$"../../computerbeeps".pitch_scale = 1
		
		MouseBlock.visible = false

	elif state == true:
		
		update_hovered("1")
			
#		$"../Dim".visible = true
		
		### Block mouse input during initial animation
		can_return = false
		MouseBlock.visible = true

		$"../../PlaneControl".play("level_info")
		$"../Background/AnimationPlayer".play("FadeIn")

		yield($"../Background/AnimationPlayer", "animation_finished")
#		yield(get_tree().create_timer(0.2),"timeout")

		#var number = Settings.chapter_progress[(Master.current_chapter)]
		var count = 0
		
		### Generate array for randomization
		var buttonarray = []
		for i in 25:
			buttonarray.append(i+1)
			
		randomize()


		### Randomly show all level buttons, re-enable mouse input at the end
		
#		$"../../noise".play()
		
		for i in 25:
			
			$"../../ui_hover".pitch_scale = 1.5

			$"../../ui_hover".play()
			
			count += 1
			var index
			var value
			
			index = rng.randi_range(0, 25 - count)
			value = buttonarray[index]
			buttonarray.remove(index)
			
			var node = get_node(str(value))
			
			if !Settings.level_progress.get(int(node.name)):
				node.is_disabled = true
				node.get_node("Highlight").visible = false
			else:
				node.is_disabled = false
				
				checkState(node)

			node.modulate = Color("#bfbfbf")
			yield(get_tree().create_timer(0.02), "timeout")

			if count == 25:

				can_return = true
				MouseBlock.visible = false
				for j in 25:
					get_child(j).modulate = Color("#ffffff")

				$"../../ui_hover".pitch_scale = 1
				
				tileShow()
				
#				$"../../noise".stop()
#				$"../Dim".visible = false
