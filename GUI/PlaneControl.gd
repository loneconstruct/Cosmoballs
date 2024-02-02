extends AnimationPlayer

export var cutoff = 20500 setget sethz

func sethz(hz):
	AudioServer.get_bus_effect(3, 0).set("cutoff_hz", hz)
