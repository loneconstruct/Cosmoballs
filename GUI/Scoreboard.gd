extends Control

onready var MouseBlock = get_parent().get_node("MouseBlock")
onready var Wipe = get_node("../WipeEffect/AnimationPlayer")

onready var can_return = false
onready var is_visible = false setget showcontainer

var chapter = 1

func showcontainer(state):
	
	self.visible = state
	
	if state == true:
		
		$"../../textdraw".playing = true
		
		for i in 25:
			$VBoxContainer.get_child(i).set("visible", true)
			
			yield(get_tree().create_timer(0.05), "timeout")
			
			if i == 24:
				can_return = true
				MouseBlock.visible = false
				$"../../textdraw".playing = false

	if state == false:
		for i in 25:
			$VBoxContainer.get_child(i).set("visible", false)
			

func _process(_delta):
	if Input.is_action_just_pressed("escape") and can_return == true:
		can_return = false
		MouseBlock.visible = true
		for i in 25:
			$VBoxContainer.get_child(i).call("fontcolor", Color(1,0,0,1))
		$"../../ui_back".play()
		Wipe.play("Wipe")
		yield(Wipe, "animation_finished")
		Wipe.play("RESET")
		showcontainer(false)
		get_parent().get_node("Main Buttons").visible = true
		MouseBlock.visible = false
