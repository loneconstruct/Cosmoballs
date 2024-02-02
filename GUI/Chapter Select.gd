extends Control

signal text_finished


onready var sprite = get_node("CenterContainer/Node2D/Sprite")
onready var is_visible : bool setget showcontainer
onready var can_return = false
onready var Wipe = get_node("../WipeEffect/AnimationPlayer")
onready var Master = Settings.Master
onready var textsound = get_node("../../textdraw")
onready var chapter = 1

#draw variables-------------------------------
export var a : float = -90
export var width : float # init by animator
export var height : float # init by animator
export var distance : float # init by animator
export var color = Color(0,1,0,1)
export var alpha = 1
export var shrink : float = 1

var shrink2
var shrink3

var bwidth = 24
var bheight = 20
var bspacing = 28
var bx = -82
var by = 70

var hold = 0
var b = true

var reveal = 0
#---------------------------------------------

func _ready():
	
	for button in $HBoxContainer.get_children():
		button.connect("pressed", self, "changechapter", [button.name])
		if Settings.chapter_progress.get(int(button.name)) == 0:
			button.modulate = Color(1,0.4,0.4,1)

func set_sprite():
	if sprite.texture.resource_path != "res://Player/Skins/" + Settings.current_skin + ".png":
		sprite.texture = load("res://Player/Skins/" + Settings.current_skin + ".png")
		
	if Settings.current_skin == "Lucky":
		
		sprite.hframes = 6
		
		sprite.frame = 5
	else:
		sprite.hframes = 1

func showcontainer(state):

	$Status.add_color_override("font_color", color)
	$Cubenav.visible_characters = 0
	$Status.visible_characters = 0
	
	self.visible = state
	$"../LaunchPosition".visible = state
	$"../InfoPosition".visible = state

	if state == true:
		
		reveal = 0
		
		interpolate($"../disclaimer", "modulate", $"../disclaimer".get("modulate"), Color(1,1,1,1))
		
		$"../InfoPosition/InfoBox".call("update_chapter", int(Master.get("current_chapter")))
		
		$"../../PlaneControl".playback_speed = 0.5
		$"../../PlaneControl".play("infobox")
		
		$"CenterContainer/Node2D/Sprite".scale = Vector2(0.5, 0.5)
		
		set_sprite()
		display_title()

		$"../../planetzoomin".play()
		$SpriteAnimate.play("PlanetZoom")
		yield($SpriteAnimate, "animation_finished")
		$"../../computerbeeps".playing = true
		$SpriteAnimate.play("Appear")
		yield($SpriteAnimate, "animation_finished")
		yield(get_tree().create_timer(1.0), "timeout")
		
	if state == false:
		color = Color(0,1,0,1)
		$"CenterContainer/Node2D/Sprite".visible = false
		


# ---- tween properties

func interpolate(node, property, initvalue, newvalue):
	$Tween.interpolate_property(node, property, initvalue, newvalue, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0)
	$Tween.start()

# ---- display title label, initial sequence

func display_title():

	reveal = 0

	display_text("Cubenav", "CUBENAV SYSTEM 1.0", 1.0, 0.03)
	yield(self,"text_finished")
	display_text("Status", "CURRENTLY ORBITING...", 1.5, 0.05)
	yield(self,"text_finished")


	while reveal != 6:
		
		textsound.pitch_scale = 0.8
		textsound.playing = true
		$HBoxContainer.get_node(str(reveal+1)).visible = true
		reveal += 1
		yield(get_tree().create_timer(0.1),"timeout")
		
		if reveal == 6:
			textsound.playing = false
			$"../MouseBlock".visible = false
			can_return = true
			b = true
			$"../../PlaneControl".playback_speed = 1
	
	$"../MouseBlock".visible = false
	

# ---- alter text label

func display_text(node, string, pitch, rate):
	
	node = get_node(node)
	
	textsound.pitch_scale = pitch
	textsound.playing = true
	
	node.text = string
	var chars = node.get_total_character_count()
	
	for i in (chars + 1):
		node.visible_characters = i 
		yield(get_tree().create_timer(rate),"timeout")
	
	textsound.playing = false
	
	emit_signal("text_finished")


#----- GUI drawing

func _draw():
	
	# orbit circle
	draw_arc(
	Vector2(0,0), #origin
	abs(distance), #radius
	deg2rad(0), deg2rad(360), #from angle, to angle
	60, #points
	color, 1.01, false) #color, thickness, antialiasing
	
	# shrinking circle 
	draw_arc(
	Vector2(0,0), #origin
	(abs(distance) * shrink), #radius
	deg2rad(0), deg2rad(360), #from angle, to angle
	60, #points
	color, 1, false) #color, thickness, antialiasing

	# shrinking circle 2
	draw_arc(
	Vector2(0,0), #origin
	(abs(distance) * shrink2), #radius
	deg2rad(0), deg2rad(360), #from angle, to angle
	60, #points
	color, 1, false) #color, thickness, antialiasing

	# shrinking circle 3
	draw_arc(
	Vector2(0,0), #origin
	(abs(distance) * shrink3), #radius
	deg2rad(0), deg2rad(360), #from angle, to angle
	60, #points
	color, 1, false) #color, thickness, antialiasing

	if Settings.chapter_progress.get(Master.get("current_chapter")) != 0:
		
		# center line ----------------------------
		draw_line(
		Vector2(0,0),
		Vector2( 
		cos(deg2rad(a)) * distance, #position x
		sin(deg2rad(a)) * distance), #position y
		color, 1.01, false)

		# black rectangle ====================================================
		draw_rect(
		Rect2(Vector2( 
		cos(deg2rad(a)) * distance - (width/2), #position x
		sin(deg2rad(a)) * distance - (height/2)), #position y
		Vector2(width, height)), #dimensions
		Color(0,0,0,1), true, 1, false) #color, filled, thickness, antialiasing

		# outline rectangle ==================================================
		draw_rect(
		Rect2(Vector2( 
		cos(deg2rad(a)) * distance - (width/2), #position x
		sin(deg2rad(a)) * distance - (height/2)), #position y
		Vector2(width, height)), #dimensions
		color, false, 1.01, false) #color, filled, thickness, antialiasing

	# button outlines ====================================================
	for i in 6:
		if (i + 1) <= reveal:
			var c = Color(0,1,0,1)
			var t = 1
			
			if i + 1 == Master.get("current_chapter"):
				t = 1.2
				
			if Settings.chapter_progress.get(i + 1) == 0:
				c = Color(1,0,0,1)
			
			draw_rect(
			Rect2(Vector2( 
			bx + (i*bspacing), #position x
			by), #position y
			Vector2(bwidth, bheight)), #dimensions
			c, false, t, false) #color, filled, thickness, antialiasing


func _process(_delta):
	
	if Settings.windowmode == "720p" and sprite.material.get("shader_param/width") != 1:
		sprite.material.set_shader_param("width", 1)

	elif sprite.material.get("shader_param/width") != 0.5:
		sprite.material.set_shader_param("width", 1)
	
	if visible == true:
		# move player sprite with orbit
		sprite.position = Vector2(
		cos(deg2rad(a)) * distance + $CenterContainer/Planet.rect_position.x,
		sin(deg2rad(a)) * distance + $CenterContainer/Planet.rect_position.y)
		$CenterContainer/Node2D/Flash.position = sprite.position
		update()
	
	if Settings.chapter_progress.get(Master.get("current_chapter")) == 0:
		if $CenterContainer/Node2D.visible == true:
			$CenterContainer/Node2D.visible = false
	else:
		if $CenterContainer/Node2D.visible == false:
			$CenterContainer/Node2D.visible = true

# shrink value wrapping

	shrink = wrapf(shrink, 0.0, 1.0)
	shrink2 = wrapf(shrink + 0.33, 0.0, 1.0)
	shrink3 = wrapf(shrink + 0.66, 0.0, 1.0)

# Leave menu

	if Input.is_action_just_pressed("escape") and can_return == true:
		
		can_return = false
		
		hide_buttons()
		
		$"../../PlaneControl".play_backwards("infobox")
		display_text("Status", "SHUTTING DOWN", 0.8, 0.06)
		$Status.add_color_override("font_color", Color(1,0,0,1))
		$"../../ui_select".play()
		
		$"../../planetzoomout".play()
		$SpriteAnimate.play("Disappear")
		yield($SpriteAnimate,"animation_finished")
		$SpriteAnimate.play_backwards("PlanetZoom")
		yield($SpriteAnimate,"animation_finished")
		$"../../computerbeeps".playing = false
		
		interpolate($"../disclaimer", "modulate", $"../disclaimer".get("modulate"), Color(1,1,1,0))
		
		$"../../ui_back".play()
		
		transition("Main Buttons")

func hide_buttons():
	while reveal != 0:
		$HBoxContainer.get_node(str(reveal)).visible = false
		reveal -= 1
		yield(get_tree().create_timer(0.1),"timeout")

func levelselect():
 
	$"../../launch".play()
	$"SpriteAnimate".play("Deploy")
#	yield($SpriteAnimate, "animation_finished")
	yield(get_tree().create_timer(1.6), "timeout")
	$"../../computerbeeps".playing = false
	interpolate($"../disclaimer", "modulate", $"../disclaimer".get("modulate"), Color(1,1,1,0))
	$"../../wipe".play()
	transition("Level Select")

# Called after shut-down animation

func transition(menu):
	
	$"../MouseBlock".visible = true
	
	
	Wipe.play("Wipe")
	yield(Wipe, "animation_finished")
	Wipe.play("RESET")
	
	for i in 6:
		$HBoxContainer.get_node(str(i+1)).visible = false
	
	showcontainer(false)
	
	if menu == "Main Buttons":
		get_parent().get_node(str(menu)).visible = true
		$"../MouseBlock".visible = false
		
	else:
		get_parent().get_node(str(menu)).is_visible = true

#----------------------------------------------------------

func changechapter(number):
	
	if chapter != int(number):
		if Settings.chapter_progress.get(int(number)) != 0:
			$"../../ui_select".play()
			chapter = int(number)
			$"CenterContainer/Planet".texture = load("res://GUI/Planets/Chapter " + str(chapter) + ".png")
			Master.current_chapter = chapter
	
			$"../InfoPosition/InfoBox".call("update_chapter", chapter)

func _on_Launch_pressed():
	$"../MouseBlock".visible = true
	can_return = false

	$"../../ui_select".play()
	yield(get_tree().create_timer(0.1), "timeout")

	textsound.volume_db = -80
	display_text("Status", "LAUNCH INITIATED", 1.3, 0.05)
	$"../../PlaneControl".play_backwards("infobox")
	levelselect()

	yield(self, "text_finished")

	textsound.volume_db = 0
	
