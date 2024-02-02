extends StaticBody2D

export var muted = false
export var closed = true
onready var defaultstate = closed
onready var animating = false

onready var closing = false
onready var t = 0

func _ready():


	if closed == true:
		$Sprite.frame = 0
		$CollisionShape2D.disabled = false
	if closed == false:
		$Sprite.frame = 7
		$CollisionShape2D.disabled = true

#--------------------------------------------
func reset_state():
	if closed != defaultstate and animating == true:
		$AnimationPlayer.play_backwards($AnimationPlayer.current_animation)
		closed = defaultstate
	elif closed != defaultstate:
		toggle_door()
#--------------------------------------------
func toggle_door():

	if closed == false and animating == false:
		closing = true
		animating = true
		$AnimationPlayer.play("Close")
		if muted == false:
			$"Door Close".play()
		closed = true
	elif closed == true and animating == false:
		animating = true
		$AnimationPlayer.play("Open")
		if muted == false:
			$"Door Open".play()
		closed = false
	
#--------------------------------------------
func _on_AnimationPlayer_animation_finished(_anim_state):
	closing = false
	animating = false

func _process(_delta):
	if closing == true:
		t +=1
		if t >= 10:
			closing = false
			t = 0
