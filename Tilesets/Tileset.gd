extends TileMap

func _ready():
	if "Background" in self.name:
			self.occluder_light_mask = 0
