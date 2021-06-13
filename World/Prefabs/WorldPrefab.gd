extends Node2D

var entry
var exit
var player

func move_entry_to(node2d):
	global_position = node2d.global_position - entry.global_position

func _ready():
	entry = get_node("Entry")
	exit = get_node("Exit")
	player = get_tree().get_root().get_node("World/Player")
	
	for node in get_children():
		if node is Spike:
			node.connect("player_joy_hit_by_spike", player, "on_player_joy_hit")
			node.connect("player_ned_hit_by_spike", player, "on_player_ned_hit")
		if node is Pickup:
			node.connect("player_picked_up", player, "on_player_pickup")
		if node is Coin:
			node.connect("player_got_coin", player, "on_player_coin_got")
		if node is TouchableZone:
			node.player = player
			player.connect("probe_touchable", node, "on_player_probe_touchable")
			node.connect("probe_touchable_succeeded", player, "toggle_fixed")
