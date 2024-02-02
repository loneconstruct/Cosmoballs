extends KinematicBody2D
###########################################
export var UP = false
export var DOWN = false
export var LEFT = false
export var RIGHT = false
export var UP_LEFT = false
export var UP_RIGHT = false
export var DOWN_LEFT = false
export var DOWN_RIGHT = false
###########################################
onready var start_position = Vector2.ZERO
onready var velocity = Vector2.ZERO
onready var speed = 100
onready var start_direction = Vector2.ZERO
onready var teleport_enabled = false
onready var redirect_enabled = false
onready var muted = true
onready var in_door = false

###########################################
func _ready():
	
	$CPUParticles2D.emitting = false
	$Ball.visible = false
	$Flash.visible = false
	
	if UP == true:
		start_direction = Vector2(0,-1)
	if DOWN == true:
		start_direction = Vector2(0,1)
	if LEFT == true:
		start_direction = Vector2(-1,0)
	if RIGHT == true:
		start_direction = Vector2(1,0)
	if UP_LEFT == true:
		start_direction = Vector2(-1,-1)
	if UP_RIGHT == true:
		start_direction = Vector2(1,-1)
	if DOWN_LEFT == true:
		start_direction = Vector2(-1,1)
	if DOWN_RIGHT == true:
		start_direction = Vector2(1,1)

	start_position = global_position

func teleport_toggle(state):
	teleport_enabled = state
func redirect_toggle(state):
	redirect_enabled = state
func mute_toggle(state):
	muted = state

func _process(delta):

	move_and_collide(velocity * delta)

func disappear():
	$CPUParticles2D.emitting = false
	redirect_enabled = false
	teleport_enabled = false
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Disappear")
	
func appear():

	velocity = Vector2.ZERO
	global_position = start_position
	$AnimationPlayer.play("Appear")

func _on_Area2D_body_entered(body):
	if (body.get("closing") == false or body.get("closing") == null) and (in_door == false):
		velocity = velocity * -1
		if muted == false:
			$Bounce.pitch_scale = rand_range(0.45, 0.7)
			$Bounce.play()

			
	elif body.get("closing") == true:
		in_door = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("Door") == true:
		in_door = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Appear":
		muted = false
		$CPUParticles2D.emitting = true
		velocity = start_direction.normalized() * speed
		redirect_enabled = true
		teleport_enabled = true
