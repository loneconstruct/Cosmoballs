extends Node2D

onready var player = $Player
onready var ending = false
onready var endPosition = Vector2.ZERO
onready var canPause = false

export var music = ""

func _ready():
	self.pause_mode = (Node.PAUSE_MODE_STOP)

func EndLevel(end_position):
	canPause = false
	get_parent().call("stop_timer", true)
	$"Player Finish".get_node("AnimationPlayer").call("play", "Activated")
	endPosition = end_position
	player.input_toggle = false
	player.velocity = Vector2.ZERO
	player.get_node("AnimationPlayer").call("play", "Spin")
	ending = true
	$AnimatorDelay.start()
	AudioServer.set_bus_mute(1, true)
	$"End SFX".play()
	
func _process(delta):
	if ending == true:
		player.global_position = player.global_position.move_toward(endPosition, delta * 25)

#-----------------------------------------------
	if Input.is_action_just_pressed("escape") and get_parent().name == "Master" and canPause == true:
		get_parent().call("pause_menu")
		
	if Input.is_action_just_pressed("restart") and get_parent().name == "Master" and canPause == true:
		get_node("Player").call("_on_Area2D_body_entered", null)
		
#-----------------------------------------------
func _advance_stage():
	get_parent().call("advance_stage")
	queue_free()

func _on_AnimatorDelay_timeout():
	$Animator.play("ZoomOut")

#-----------------------------------------------
