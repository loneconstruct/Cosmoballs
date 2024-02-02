extends Node2D

onready var start_position

func _ready():
	start_position = global_position

func _on_Area2D_area_entered(_area):
	get_parent().call("EndLevel", start_position)

