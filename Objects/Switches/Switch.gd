extends Node2D

onready var is_player_inside = false
export var color = "Color"
onready var pressable = true
var col 
var a 

func _ready():
	$Idle.pitch_scale = rand_range(1, 4)
	$"Activation Sprite".visible = false
	
	a = 0
	
	match color:
		"Red":
			col = Color(1,0,0,0)
		"Blue":
			col = Color(0,0,1,0)
		"Yellow":
			col = Color(1,1,0,0)
		"Green":
			col = Color(0,1,0,0)


func _process(_delta):
	
	update()
	
	if is_player_inside == true and Input.is_action_pressed("interact") and pressable == true:
		pressable = false
		$Timer.start()
		get_tree().call_group(""+color+" Door", "toggle_door")
		$"Activation Animation".play("Activate")
		showlines()
	

func monitoring(state):
	$CheckSpace.monitoring = state

func _on_CheckSpace_area_entered(area):
	is_player_inside = true
	$AnimationPlayer.playback_speed = 2
	$CPUParticles2D.emitting = true
	$ActivationRange.play()
	$Idle.stop()
	area.get_parent().get_node("Shader").call("play", color)
	
func _on_CheckSpace_area_exited(area):
	is_player_inside = false
	$AnimationPlayer.playback_speed = 1
	$CPUParticles2D.emitting = false
	$ActivationRange.stop()
	$Idle.play()
	area.get_parent().get_node("Shader").call("play", "Idle")

func _on_Timer_timeout():
	pressable = true

func _draw():
	for door in get_tree().get_nodes_in_group(color + " Door"):
		draw_line(self.global_position - self.position, door.position - self.position, Color(col.r, col.g, col.b, a), 1.2, true)

func showlines():
	$Tween.interpolate_property(self, "a", 1, 0, 1, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	$Tween.start()
