extends Node2D

export var channel = 1
onready var paired_channel
onready var coordinates = global_position
onready var teleport_registry = get_parent().get_node("Teleport Registry")

func _ready():
	teleport_registry.call("create_destination", channel, coordinates)

	if channel % 2 != 0:
		paired_channel = channel - 1
	else:
		paired_channel = channel + 1

func _on_Area2D_area_entered(area):
	$AnimationPlayer.play("Activated")
	if area.get_parent().teleport_enabled == true:
		teleport(area.get_parent())

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Activated":
		$AnimationPlayer.play("Idle")

func teleport(object):
	if object.get_collision_layer_bit(3) == true:
		object.get_node("Teleport").call("play")
	if object.get_collision_layer_bit(4) == true:
		object.call("mute_toggle", true)
	object.call("teleport_toggle", false)
	object.global_position = teleport_registry.registry[paired_channel]

func _on_Area2D_area_exited(area):
	area.get_parent().call("teleport_toggle", true)


func _on_Reciever_Detection_area_entered(area):
	if area.get_parent().teleport_enabled == false:
		$AnimationPlayer.play("Activated")
	if area.get_parent().get_collision_layer_bit(4) == true:
		area.get_parent().call("mute_toggle", false)


