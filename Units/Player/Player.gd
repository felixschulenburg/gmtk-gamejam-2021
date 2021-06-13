extends Node2D
class_name Player

var ChainNodeScene = preload("ChainNode.tscn")
var ChainJointScene = preload("ChainJoint.tscn")

onready var joy = $Joy
onready var ned = $Ned
onready var joy_joint = $Joy/PinJoint2D
onready var ned_joint = $Ned/PinJoint2D
onready var joy_anchor = $Joy/Anchor
onready var ned_anchor = $Ned/Anchor
onready var camera = $Camera2D
onready var launch_line = $LaunchLine
onready var invulnerability_timer = $InvulnerabilityTimer
onready var player_ui = $CanvasLayer/PlayerUI

var joy_fixed = true
var ned_fixed = false

export var start_health = 5
export var num_segments = 20
export var len_segments = 10
export var launch_speed = 250

var health setget set_health, get_health
var nodes = []
var segments = []

var dragging = false
var probing = false

signal probe_touchable
signal player_died

func _ready():
	launch_line.add_point(Vector2.ZERO)
	launch_line.add_point(Vector2.ZERO)
	
	if joy_fixed:
		joy.mode = RigidBody2D.MODE_STATIC
	if ned_fixed:
		ned.mode = RigidBody2D.MODE_STATIC
	
	joy.position = Vector2.ZERO
	ned.position = Vector2(0, num_segments * len_segments)
	
	joy_joint.set_node_a(joy.get_path())
	joy_joint.set_node_b(joy_anchor.body.get_path())
	
	ned_joint.set_node_a(ned_anchor.body.get_path())
	ned_joint.set_node_b(ned.get_path())
	
	for i in range(num_nodes()):
		var n = ChainNodeScene.instance()
		add_child(n)
		n.position = Vector2(0, (i + 1) * len_segments)
		nodes.push_back(n)
	
	for i in range(num_segments):
		var n1 = joy_anchor.body if i == 0 else nodes[i - 1].body
		var n2 = ned_anchor.body if i == num_segments - 1 else nodes[i].body
		var s = ChainJointScene.instance()
		n1.add_child(s)
		s.set_nodes(n1, n2)
		segments.push_back(s)
	
	self.health = start_health

func _process(delta):	
	if dragging:
		launch_line.points[0] = get_active().global_position
		launch_line.points[1] = get_global_mouse_position()

func _physics_process(delta):
	camera.global_position = get_inactive().global_position

func _input(event):
	if Input.is_action_just_pressed("scroll_up"):
		add_segment()
		
	if Input.is_action_just_pressed("scroll_down"):
		remove_segment()
		
	if Input.is_action_pressed("action_space") or event.is_action_pressed("click_right"):
		probing = true
		emit_signal("probe_touchable")
	
	if event.is_action_pressed("click_left") and not dragging:
		dragging = true
		launch_line.show()
	
	if event.is_action_released("click_left") and dragging:
		dragging = false
		var drag_end = get_global_mouse_position()
		var dir = get_active().global_position - drag_end
		launch_line.hide()
		
		if not joy_fixed:
			joy_anchor.body.apply_central_impulse(dir.normalized() * launch_speed)
		for i in range(0, nodes.size()):
			nodes[i].body.apply_central_impulse(dir.normalized() * launch_speed)
		if not ned_fixed:
			ned_anchor.body.apply_central_impulse(dir.normalized() * launch_speed)

func add_segment():
	if joy_fixed:
		var n = ChainNodeScene.instance()
		add_child(n)
		n.global_position = ned.global_position
		nodes.push_back(n)
		
		ned.global_position = ned.global_position + (nodes[-1].global_position - nodes[-2].global_position).normalized() * len_segments
		segments[-1].set_nodes(nodes[-2].body, nodes[-1].body)
		
		var s = ChainJointScene.instance()
		n.body.add_child(s)
		s.set_nodes(nodes[-1].body, ned_anchor.body)
		segments.push_back(s)
	
	elif ned_fixed:
		var n = ChainNodeScene.instance()
		add_child(n)
		n.global_position = joy.global_position
		nodes.push_front(n)
		
		segments[0].set_nodes(nodes[0].body, nodes[1].body)
		
		var s = ChainJointScene.instance()
		n.body.add_child(s)
		s.set_nodes(joy_anchor.body, nodes[0].body)
		segments.push_front(s)

func remove_segment():
	if nodes.size() > 1 and segments.size() > 2:
		if joy_fixed:
			ned.global_position = nodes[-1].body.global_position
			segments[-2].set_nodes(nodes[-2].body, ned_anchor.body)
			var s = segments.pop_back()
			var n = nodes.pop_back()
	#		s.call_deferred("queue_free")
			n.call_deferred(("queue_free"))
#			update_segment_length(-1)
		
		elif ned_fixed:
			joy.global_position = nodes[1].body.global_position
			segments[0].set_nodes(joy_anchor.body, nodes[1].body)
			segments.remove(1)
			var n = nodes.pop_front()
	#		s.call_deferred("queue_free")
			n.call_deferred(("queue_free"))
#			update_segment_length(0)

#func update_segment_length(i):
#	# hack
#	segments[i].joint.disable_collision = !segments[i].joint.disable_collision
#	segments[i].joint.disable_collision = !segments[i].joint.disable_collision

func toggle_fixed():
	if probing:
		probing = false
		joy_fixed = not joy_fixed
		if joy_fixed:
			joy.mode = RigidBody2D.MODE_STATIC
		else:
			joy.mode = RigidBody2D.MODE_RIGID
		
		ned_fixed = not ned_fixed
		if ned_fixed:
			ned.mode = RigidBody2D.MODE_STATIC
		else:
			ned.mode = RigidBody2D.MODE_RIGID

func set_health(value):
	health = value
	player_ui.health = value
	check_health()

func get_health():
	return health

func get_active():
	return joy if not joy_fixed else ned

func get_inactive():
	return joy if joy_fixed else ned

func num_nodes():
	return num_segments - 1

func on_player_hit(damage):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		self.health = self.health - damage

func on_player_pickup(health_add):
	self.health = self.health + health_add

func check_health():
	if self.health <= 0:
		emit_signal("player_died")
