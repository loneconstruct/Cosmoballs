extends Node2D

export var skin = "Default"
var activated = false

func _ready():
	
	if $"../../".is_class("Viewport"):
		self.queue_free()

	visible = false
	
	if Settings.skin_unlocks[skin] == false:
		visible = true
		$Node2D/AnimationPlayer.play("Idle")

	$Node2D/Sprite.texture = load("res://Player/Skins/" + skin + ".png")
		
	if skin == "Lucky":
		$Node2D/Sprite.hframes = 6
		$Node2D/Sprite.frame = 5
	else:
		$Node2D/Sprite.hframes = 1

func _on_Area2D_area_entered(area):
	
	if area.get_parent().name == "Player" and activated == false and visible == true:
		activated = true
		Settings.skin_unlocks[skin] = true
		
		Settings.savedata()
		
		$Node2D/AnimationPlayer.play("Unlock")
		$AudioStreamPlayer.play()
		$"../../MessageBox".message("Skin Unlocked: " + skin)
