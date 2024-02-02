extends TextureRect

export(float)  var scroll_speed = 0.4
var time = 0.0

func _ready():
	self.material.set_shader_param("scroll_speed", scroll_speed)

func _process(delta):
	time += delta
	self.material.set_shader_param("time", time)
