extends Node2D

func worthy():
	$YSort/Text.text = "WORTHY"
	$Worthy.play()
	$AnimationPlayer.play("Worthy")

func unworthy():
	$YSort/Text.text = "unworthy..."
	$Unworthy.play()
	$AnimationPlayer.play("Unworthy")
	

func _on_Area2D_body_entered(body):
	if $Cooldown.is_stopped() == true and body.name == "Player":
		$Cooldown.start()
		if Settings.current_skin == "Eldritch":
			worthy()
		else:
			unworthy()

func _on_Cooldown_timeout():
	$Cooldown.stop()
