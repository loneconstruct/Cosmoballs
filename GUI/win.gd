extends Control

export var input_enabled = false

func show():
	$Position2D/DummyPlayer.call("set_sprite")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = true
	AudioServer.set_bus_mute(1, false)
	$Animation.play("ready")
	$Loop.play("fly")
	
func callmenu():
	get_parent().call("main_menu")
	$"../Main Menu".call("zoom")
	$Animation.play("RESET")

func _process(_delta):
	
	if Input.is_action_just_pressed("interact") and input_enabled == true:
		input_enabled = false
		$Animation.play("close")
	else:
		pass
