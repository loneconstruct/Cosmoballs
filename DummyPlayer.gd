extends Sprite

onready var rng = RandomNumberGenerator.new()

func _ready():
	randomize()

func set_sprite():
	if self.texture.resource_path != "res://Player/Skins/" + Settings.current_skin + ".png":
		self.texture = load("res://Player/Skins/" + Settings.current_skin + ".png")
		
	if Settings.current_skin == "Lucky":
		self.hframes = 6
		self.frame = rng.randi_range(0,5)

	else:
		self.hframes = 1
