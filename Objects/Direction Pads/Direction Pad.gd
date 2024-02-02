extends Node2D

export var direction_tag = "DOWN"
onready var direction
onready var enabled = false

func _ready():
	if direction_tag == "DOWN":
		direction = Vector2(0,1)
	if direction_tag == "LEFT":
		direction = Vector2(-1,0)
	if direction_tag == "RIGHT":
		direction = Vector2(1,0)
	if direction_tag == "UP":
		direction = Vector2(0,-1)

func toggle(state):
	enabled = state

func redirect(object):
	object.call("redirect_toggle", false)
	object.global_position = global_position
	object.velocity = direction * object.speed

func _on_Area2D_area_entered(area):
	if area.get_parent().redirect_enabled == true and enabled == true:
		redirect(area.get_parent())
func _on_Area2D_area_exited(area):
	area.get_parent().call("redirect_toggle", true)
