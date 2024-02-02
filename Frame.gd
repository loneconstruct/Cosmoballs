extends Control

onready var level = get_parent()

func _ready():
	
	if level.get_parent().is_class("Viewport"):
		
		var name = str(level.filename).lstrip("res://").rstrip(".tscn").replace(" ", String()).replace("/", String())
		
		var viewport : Viewport = get_node("../../")
		var loader = get_node("../../..")
		
		level.connect("tree_exited", loader, "on_freed")
		
		level.get_node("In-Game Camera").queue_free()
		level.get_node("Player").queue_free()
		level.get_node("Animator").queue_free()
		level.get_node("AnimatorDelay").queue_free()
		level.get_node("White Plane").queue_free()
		level.get_node("End SFX").queue_free()
		
		var balls : Array = level.get_tree().get_nodes_in_group("Ball")
		
		for i in balls.size():
			balls[i].get_node("Ball").visible = true
		

	# position / scale within viewport (110 x 80)             ! add centering code

		var width = rect_size.x
		var height = rect_size.y

		var new = Vector2(55, 40)

		if (110 / width) < (80 / height):
			level.set("scale", Vector2(110 / width, 110 / width))

		else:
			level.set("scale", Vector2(80 / height, 80 / height))


		var old = Vector2(width / 2, height / 2) * level.get("scale")
		level.set("position", level.get("scale") * Vector2(-rect_position.x, -rect_position.y) + (new - old))

		yield(VisualServer, "frame_post_draw")

		var img = viewport.get_texture().get_data()
		img.flip_y()
		img.save_png("ThumbnailCache/" + name + ".png")

		level.queue_free()

	else:
		pass
