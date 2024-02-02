extends Node2D

func _ready():
	for node in get_children():
		if node.is_in_group("Ball"):
			node.get_node("Bounce").set("volume_db", -80)
			node.get_node("AnimationPlayer").call("play", "Appear")
			node.get_node("Ball").set_material(null)
			node.set("speed", node.get("speed") * 0.295)
