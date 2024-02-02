extends ParallaxBackground

func level():
	$BackgroundAnimator.stop()
	$BackgroundGradient.visible = false
	$BackgroundPlanets.visible = false
	$Planet.visible = true


func menu():
	$BackgroundAnimator.play("default")
	$BackgroundPlanets.visible = true
	$BackgroundGradient.visible = true
	$Planet.visible = false
