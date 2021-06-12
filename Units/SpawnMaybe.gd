extends Node2D

export var spawnProbability = 100
var player

func _ready():
	if randi()% 100 > spawnProbability:
		call_deferred("queue_free")
		
	player = get_tree().get_root().get_node("World/Player")
	
	for node in get_children():
		if node is Spike:
			node.connect("player_hit_by_spike", player, "on_player_hit")
		if node is Pickup:
			node.connect("player_picked_up", player, "on_player_pickup")
