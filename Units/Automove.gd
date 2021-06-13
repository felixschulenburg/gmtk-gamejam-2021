extends Node2D


export(Array) var waypoints
export(float) var seconds_per_waypoint = 5
export(float) var waypoint_pause = 1
var currentIndex = 1
var t = 0
var is_pausing = false
var pause_counter = 0

var player

func _init():
	if waypoints.size() > 0:
		global_position = get_node(waypoints[0]).global_position

func _process(delta):
	if is_pausing:
		pause_counter += delta
		if pause_counter >= waypoint_pause:
			is_pausing = false
			pause_counter = 0
	elif waypoints.size() > 1:
		t += delta / seconds_per_waypoint
		t = clamp(t, 0, 1)
		
		if t == 1:
			currentIndex = (currentIndex + 1) % waypoints.size()
			t = 0
			is_pausing = true
		
		var wp1 = get_node(waypoints[(currentIndex + waypoints.size() - 1) % waypoints.size()])
		var wp2 = get_node(waypoints[currentIndex])
		var new_pos = lerp(wp1.global_position, wp2.global_position, quad_easing(t))
		global_position = new_pos

func quad_easing(t):
	if t < 0.5:
		return 2 * t * t
	else:
		return -2 * (t - 1) * (t - 1) + 1

func _ready():
	player = get_tree().get_root().get_node("World/Player")
	
	for node in get_children():
		if node is Spike:
			node.connect("player_joy_hit_by_spike", player, "on_player_joy_hit")
			node.connect("player_ned_hit_by_spike", player, "on_player_ned_hit")
		if node is Pickup:
			node.connect("player_picked_up", player, "on_player_pickup")
