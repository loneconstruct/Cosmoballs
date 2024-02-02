extends Node2D

onready var revealed = false
onready var animating = false

func reset_state():
	if animating == true:
		$AnimationPlayer.play_backwards($AnimationPlayer.current_animation)
	elif revealed == true:
		$AnimationPlayer.play_backwards("Reveal")
	revealed = false

func reveal():
	animating = true
	$AnimationPlayer.play("Reveal")
	$Sound.play()

func _on_Area2D_body_entered(body):
	if body.name == "Player" and revealed == false:
		revealed = true
		reveal()

func _on_AnimationPlayer_animation_finished(_anim_name):
	animating = false
