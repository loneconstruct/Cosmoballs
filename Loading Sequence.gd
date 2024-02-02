extends Node2D

onready var Master = Settings.Master
onready var viewport = $Viewport
onready var c = 1
signal done


func _ready():

	for i in 25: # !!! increase interation count when more levels are added !!!

		match i:
			(0): c = 1
			(25): c = 2
			(50): c = 3
			(75): c = 4
			(100): c = 5
			(125): c = 6
			_: pass

		i = i + 1

		if ResourceLoader.exists("res://ThumbnailCache/Chapter" + str(c) + "Level" + str(i) + ".png"):

			if i == 25:
				finished()

			continue

		viewport.add_child(load("res://Chapter " + str(c) + "/Level " + str(i) + ".tscn").instance())

		yield(self, "done")

		if i == 25:
			finished()

func on_freed():
	emit_signal("done")

func finished():
	yield(Master, "ready")
	Master.call("main_menu")
	queue_free()
