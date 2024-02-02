extends Camera2D

onready var camera_start_position = get_camera_screen_center()
onready var camera_position = Vector2.ZERO
onready var camera_near_start = true

func _process(_delta):
	
	camera_position = get_camera_screen_center()
	
	if camera_position.x >= camera_start_position.x - 100 and camera_position.x <= camera_start_position.x + 100 \
	and camera_position.y >= camera_start_position.y - 100 and camera_position.y <= camera_start_position.y + 100:
		camera_near_start = true
	
	else:
		camera_near_start = false
