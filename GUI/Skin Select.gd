extends Control

onready var is_visible : bool setget showcontainer
onready var Wipe = get_node("../WipeEffect/AnimationPlayer")
var can_return = false
var chapter = 1

func _process(_delta):
	
	if Input.is_action_just_pressed("escape") and can_return == true:
		
		can_return = false
		$"../MouseBlock".visible = true
		$SkinDemo.disable()
		$SkinDemo.get("player").visible = false
		
		$"../../ui_back".play()
		
		$"../../menu_slide".pitch_scale = 3
		$"../../menu_slide".play()
		$"../../PlaneControl".playback_speed = 3
		$"../../PlaneControl".play_backwards("MenuShiftLeft")

#		$"../../PlaneControl".play_backwards("skin_chapter")
		
		
		Wipe.play("Wipe")
		yield(Wipe, "animation_finished")
		Wipe.play("RESET")
		
		showcontainer(false)
		
		$"../MouseBlock".visible = false
		get_parent().get_node("Main Buttons").visible = true
		$"../../PlaneControl".playback_speed = 1

func check():
	
	for node in get_tree().get_nodes_in_group("Skin Button"):

		if node.name == Settings.current_skin:
			node.selected = true
			node.Highlight.modulate = Color(1,1,0,1)
			
		else:
			node.selected = false
			node.Highlight.modulate = Color(1,0,0,0.15)
		
		if node.disabled == true:
			node.Highlight.visible = false
		else:
			node.Highlight.visible = true
	
	if can_return == true:
	
		$SkinDemo.initiate()

	
func showrow(n):
	var total = $"Chapter 1".get_child_count()
	var num
	
	for i in 5:
		num = i + ((n-1) * 5)
		if num >= total:
			break
		else:
			$"Chapter 1".get_child(num).visible = true


func showcontainer(state : bool):
	
	$SkinDemo.mute = false
	
	self.visible = state
	$"../SkinChapterPosition".visible = state
	

	if state == true:
		
		$"Chapter 1".visible = false
		$SelectSkin.visible = false
		$SkinName.visible = false
		$SkinName.text = Settings.current_skin
		for i in $"Chapter 1".get_children():
			i.visible = false
		
		$"../../menu_slide".pitch_scale = 1
		$"../../menu_slide".play()
		
		$"../../PlaneControl".play("MenuShiftLeft")
		$SkinDemo.visible = true
		$"../../ui_generic".pitch_scale = 1.68
		
		check()
		
		for node in get_tree().get_nodes_in_group("Skin Button"):
			
			if Settings.skin_unlocks[node.name] == true: 
				node.disabled = false
				node.get_node("Sprite").visible = true

			else:
				node.disabled = true
				node.get_node("Sprite").visible = false
		
		$AnimationPlayer.play("reveal")
		yield($AnimationPlayer, "animation_finished")
		$SkinDemo.initiate()
		yield(get_tree().create_timer(0.2), "timeout")
		
		$"../MouseBlock".visible = false
		
		$SkinDemo.mute = true

	else:
		can_return = false
		chapter = 1
		$Sound.visible = false
		
		Settings.savedata()
