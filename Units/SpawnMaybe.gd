extends Node2D

export var spawnProbability = 100
var player

func _ready():
	var rndnum = randi() % 100
	#print(rndnum)
	if rndnum > spawnProbability:
		call_deferred("queue_free")
		
	player = get_tree().get_root().get_node("World/Player")
	
	for node in get_children():
		if node is Spike:
			node.connect("player_joy_hit_by_spike", player, "on_player_joy_hit")
			node.connect("player_ned_hit_by_spike", player, "on_player_ned_hit")
		if node is Pickup:
			node.connect("player_picked_up", player, "on_player_pickup")
		if node is TouchableZone:
			node.player = player
			player.connect("probe_touchable", node, "on_player_probe_touchable")
			node.connect("probe_touchable_succeeded", player, "toggle_fixed")
