extends Node2D

onready var default = load("res://Player/Player.tscn")

onready var player = $Player

var pos : Vector2

var mute = false

func _ready():
	
	pos = player.position

func initiate():
	
	
	
	get_parent().can_return = false
	
	player.queue_free()
	player = default.instance()
	add_child(player)
	player.get_node("AnimationPlayer").set("playback_speed", 2)
	if mute == true:
		player.get_node("Spawn").set("volume_db", -80)
	else:
		player.get_node("Spawn").set("volume_db", -2)
	player.position = pos
	player.level_ready = true
	player.set_sprite()
	player.call("_on_Spawn_Delay_timeout")
	yield(player.get_node("AnimationPlayer"),"animation_finished")
	get_parent().can_return = true

func disable():
	player.input_toggle = false

func enable():
	player.input_toggle = true
