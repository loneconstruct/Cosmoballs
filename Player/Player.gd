extends KinematicBody2D

onready var Master = Settings.Master
onready var velocity = Vector2.ZERO
onready var start_position = Vector2.ZERO
onready var input_toggle = false
onready var camera_check = true
onready var spawn_timer = $"Spawn Delay"
onready var moving = false
onready var movesound = $Moving

export var level_ready = false

onready var teleport_enabled = true

onready var rng = RandomNumberGenerator.new()


onready var levelcamera = get_parent().get_node_or_null("In-Game Camera")

func _ready():
	
	if get_parent().name == "SkinDemo":
		$Spawn.bus = "SFX2"
	
	$Flash.visible = false
	$Light2D.energy = 0
	
	$Player.scale = Vector2(1,1)
	$Player.rotation_degrees = 0
	
	$Player.visible = false

	start_position = Vector2(global_position)

	
func teleport_toggle(state):
	teleport_enabled = state

func _process(_delta):

	var sound_playing = movesound.playing
	if levelcamera != null:
		if camera_check == true and levelcamera.camera_near_start == true and level_ready == true:
			spawn_timer.start()
			camera_check = false
			get_parent().get_node("Player Spawner").call("animate")
	
	if input_toggle == true: 
		velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		velocity = velocity.normalized() * 100
		if Input.is_action_pressed("move_fine"):
			velocity = velocity.normalized() * 35

	###################################################
	# NOCLIP MODE
	
#	if Input.is_action_just_pressed("noclip"):
#		if !$Area2D/CollisionShape2D.disabled:
#
#			$Area2D/CollisionShape2D.disabled = true
#			$CollisionPolygon2D.disabled = true
#			$Debug.visible = true
#
#		else:
#
#			$Area2D/CollisionShape2D.disabled = false
#			$CollisionPolygon2D.disabled = false
#			$Debug.visible = false
	
	###################################################
	
	if (Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")) and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		movesound.pitch_scale = 1.20
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up"):
		movesound.pitch_scale = 1.42
	else:
		movesound.pitch_scale = 1
	#------------------------------
	if Input.is_action_pressed("move_fine"):
		movesound.pitch_scale = movesound.pitch_scale * 0.6
	#################################################################
	if input_toggle == true and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")):
		$CPUParticles2D.emitting = true
		moving = true
	else:
		$CPUParticles2D.emitting = false
		moving = false
	#################################################################
	if moving == true and sound_playing == false:
		movesound.playing = true
	if moving == false and sound_playing == true:
		movesound.playing = false
	#################################################################
	velocity = move_and_slide(velocity)
	
#--------------------------------------------------------------------
func _on_Spawn_Delay_timeout():
	get_tree().call_group("Ball", "appear")
	self.set_collision_mask_bit(7, true)
	$Area2D.set_collision_mask_bit(4, true)
	$AnimationPlayer.play("Appear")
#--------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Appear":
		
		if get_parent().name != "SkinDemo":
			teleport_enabled = true
			get_tree().call_group("Switch", "monitoring", true)
			input_toggle = true
			get_tree().call_group("Director", "toggle", true)
			
			if Master != null:
				Master.call("start_timer")
			
			yield(get_tree().create_timer(0.15), "timeout")
			
			for i in (get_tree().get_nodes_in_group("Door")):
				i.get_node("Door Open").set("volume_db", 6)
				i.get_node("Door Close").set("volume_db", 9)
			
			get_parent().set("canPause", true)
		
		else:
			input_toggle = true
		
	elif anim_name == "Disappear":
		camera_check = true
		global_position = start_position
#--------------------------------------------------------------------
func _on_Area2D_body_entered(_body):
	
	get_parent().set("canPause", false)
	
	if Master != null:
		Master.call("stop_timer", false)
	
	get_tree().call_group("Director", "toggle", false)
	get_tree().call_group("Switch", "monitoring", false)
	self.set_collision_mask_bit(7, false)
	$Area2D.set_collision_mask_bit(4, false)
	velocity = Vector2.ZERO
	input_toggle = false
	$AnimationPlayer.play("Disappear")
	for i in (get_tree().get_nodes_in_group("Door")):
		i.get_node("Door Open").set("volume_db", -80)
		i.get_node("Door Close").set("volume_db", -80)
	get_tree().call_group("Door", "reset_state")
	get_tree().call_group("Ball", "disappear")
#--------------------------------------------------------------------

func particle_config(properties : Array):
	for i in properties.size():
		
		if int(i) % 2 == 0:
		
			$CPUParticles2D.set(str(properties[i]), properties[i+1])
		
		else:
			continue

func set_sprite():

	if $Player.texture.resource_path != "res://Player/Skins/" + Settings.current_skin + ".png":
		$Player.texture = load("res://Player/Skins/" + Settings.current_skin + ".png")
		$Player/Holographic.texture = load("res://Player/Skins/" + Settings.current_skin + ".png")
		
	if Settings.current_skin == "Lucky":
		rng.randomize()
		$Player.hframes = 6
		$Player/Holographic.hframes = 6
		$Player.frame = rng.randi_range(0,5)
		$Player/Holographic.frame = $Player.get("frame")
	else:
		$Player.hframes = 1
		$Player/Holographic.hframes = 1
	
	#individual skin configurations
	
	match Settings.current_skin:
		
		"Default": 
			pass
			
		"Terminal":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Terminal.wav")
				$Moving.volume_db = -3

			particle_config([
				"texture", load("res://Player/Particles/pTerminal.png"),
				"material", load("res://Player/Particles/pTerminal.tres"),
				"scale_amount", 1,
#				"initial_velocity", 0,
				"anim_offset", 1,
				"anim_offset_random", 1,
				"emission_rect_extents", Vector2(0,0)])
		
		"Lucky":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Lucky.wav")
				$Moving.volume_db = -3
			particle_config([
				"angular_velocity_curve", load("res://Player/Particles/aLucky.tres"),
				"texture", load("res://Player/Particles/pLucky.png"),
				"material", load("res://Player/Particles/pLucky.tres"),
				"scale_amount", 0.5,
				"anim_offset", 1,
				"anim_offset_random", 1,
				"gravity", Vector2(0, 200),
				"initial_velocity", 20,
				"lifetime", 1,
				"amount", 15])
		
		"Rainbow Splatter": 
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Rainbow Splatter.wav")
				$Moving.volume_db = -3
			
			particle_config([
				"hue_variation", 1,
				"hue_variation_random", 1,
				"color", "#9d00a7",
				"scale_amount", 2.5,
				"scale_amount_random", 0.5,
				"amount", 40,
				"emission_rect_extents", Vector2(3,3)])

		"Ghost":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Ghost.wav")
				$Moving.volume_db = -12
			
			particle_config([
				"texture", load("res://Player/Particles/pGhost.png"),
				"material", load("res://Player/Particles/pGhost.tres"),
				"scale_amount", 1,
				"anim_offset", 1,
				"anim_offset_random", 1])
		
		"Hypnotic":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Hypnotic.wav")
				$Moving.volume_db = -6
			particle_config([
				"radial_accel", -20,
				"anim_speed", 5,
				"scale_amount", 0.75,
				"texture", load("res://Player/Particles/pHypnotic.png"),
				"material", load("res://Player/Particles/pHypnotic.tres")
				])
			
		"Eldritch":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Eldritch.wav")
				$Moving.volume_db = -12

			particle_config([
				"scale_amount", 4,
				"scale_amount_random", 0.5,
				"initial_velocity", 0,
				"amount", 70,
				"color_initial_ramp", load("res://Player/Particles/gEldritch.tres"),
				"lifetime", 1.5,
				"emission_rect_extents", Vector2(2,2)])

		"Construct":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Construct.wav")
				$Moving.volume_db = -12
			
			particle_config([
				"scale_amount", 7,
				"scale_amount_curve", load("res://Player/Particles/sConstruct.tres"),
				"scale_amount_random", 0.25,
				"amount", 80,
				"color_ramp", load("res://Player/Particles/cConstruct.tres")
			])

		"Mystery Crystal":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Mystery Crystal.wav")
				$Moving.volume_db = -15

			particle_config([
				"anim_offset", 1,
				"anim_offset_random", 1,
				"angle", 180,
				"angle_random", 1,
				"scale_amount", 0.75,
				"texture", load("res://Player/Particles/pMystery Crystal.png"),
				"material", load("res://Player/Particles/pMystery Crystal.tres")
				])
			
		"Tech Cube":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Tech Cube.wav")
				$Moving.volume_db = -17

			particle_config([
				"texture", load("res://Player/Particles/pTech Cube.png"),
				"material", load("res://Player/Particles/pTech Cube.tres"),
				"anim_speed", 2,
				"lifetime", 1,
				"color_ramp", load("res://Player/Particles/gTech Cube.tres"),
				"scale_amount", 0.85,
				"spread", 0,
				"amount", 8,
				"emission_rect_extents", Vector2(0,0),
				"initial_velocity", 0,
				"initial_velocity_random", 0])		

		"Be the Block":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Be the Block.wav")
				$Moving.volume_db = -8
			particle_config([
				"texture", load("res://Player/Particles/pBe the Block.png"),
				"scale_amount", 1,
				"spread", 0,
				"amount", 15,
				"emission_rect_extents", Vector2(0,0),
				"initial_velocity", 0,
				"initial_velocity_random", 0])
		
		"Bento":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Bento.wav")
				$Moving.volume_db = -2
			particle_config([
				"texture", load("res://Player/Particles/pBento.png"),
				"material", load("res://Player/Particles/pTerminal.tres"),
				"scale_amount", 1,
				"anim_offset", 1,
				"anim_offset_random", 1,
				"initial_velocity", 20,
				"damping", 20
				])
		
		"Handheld":
			if Settings.skinsounds == true:
				$Moving.stream = load("res://Player/Skins/Handheld.wav")
				$Moving.volume_db = -7
		
			particle_config([
				"lifetime", 2,
				"amount", 20,
				"initial_velocity", 0,
				"scale_amount", 0.5,
				"scale_amount_curve", load("res://Player/Particles/sHandheld.tres"),
				"color_ramp", load("res://Player/Particles/cHandheld.tres"),
				"texture", load("res://Player/Particles/pHandheld.png"),
				"emission_rect_extents", Vector2(0,0)
			])
