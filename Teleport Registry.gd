extends Node

onready var size
onready var registry = PoolVector2Array()

func _ready():
	size = get_tree().get_nodes_in_group("Teleporter").size()
	registry.resize(size)

func create_destination(channel, coordinates):
	registry.set(channel, coordinates)
	
