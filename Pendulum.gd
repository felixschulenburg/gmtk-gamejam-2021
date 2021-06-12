extends Node2D
class_name Pendulum

onready var anchor = $Anchor
onready var anchor_joint = $Anchor/PinJoint2D
onready var camera = $Camera2D

var ChainLink = preload("ChainLink.tscn")
var ChainJoint = preload("ChainJoint.tscn")
var Projectile = preload("Projectile.tscn")

export var chain_length = 10
export var joint_length = 30

export var projectile_speed = 750
export var projectile_offset = 20

var links = []
var joints = []

var chain_direction = 1

var dragging

func _ready():
	var new_link = ChainLink.instance()
	add_child(new_link)
	links.push_back(new_link)
#	new_link.fixed = true
	
	anchor_joint.set_node_a(anchor.get_path())
	anchor_joint.set_node_b(new_link.get_path())
	
	for i in range(chain_length):
		add_link(Vector2(0, joint_length))

func add_link(offset):
	var new_link = ChainLink.instance()
	add_child(new_link)
	if chain_direction == -1:
		new_link.global_position = links[0].global_position - offset
		links.push_front(new_link)
		
		var new_joint = ChainJoint.instance()
		links[1].add_child(new_joint)
		new_joint.set_links(links[1], links[0])
		joints.push_front(new_joint)
	else:
		new_link.global_position = links[-1].global_position + offset
		links.push_back(new_link)
		
		var new_joint = ChainJoint.instance()
		links[-1].add_child(new_joint)
		new_joint.set_links(links[-2], links[-1])
		joints.push_back(new_joint)
	
	if chain_direction == -1:
		links[0].is_last_link = true
	else:
		links[-1].is_last_link = true

func _input(event):
	if event.is_action_pressed("click_left") and not dragging:
		dragging = true
		if chain_direction == -1:
			links[0].line.show()
		else:
			links[-1].line.show()
	if event.is_action_released("click_left") and dragging:
		dragging = false
		var drag_end = get_global_mouse_position()
		var dir
		if chain_direction == -1:
			dir = links[0].global_position - drag_end
		else:
			dir = links[-1].global_position - drag_end
		shoot(dir)
	if event.is_action_pressed("click_right"):
		change_direction()

func shoot(dir):
	for i in range(1, links.size()):
		links[i].apply_central_impulse(-dir)
	if chain_direction == -1:
		links[0].line.hide()
	else:
		links[-1].line.hide()
	
	if (links.size() > 2):
		if chain_direction == -1:
			joints[0].connected = false
			joints[0].call_deferred("queue_free")
			links[0].call_deferred("queue_free")
			links.pop_front()
			joints.pop_front()
		else:
			joints[-1].call_deferred("queue_free")
			links[-1].call_deferred("queue_free")
			links.pop_back()
			joints.pop_back()
		
		var p = Projectile.instance()
		add_child(p)
		
		if chain_direction == -1:
			p.global_position = links[0].global_position + dir.normalized() * projectile_offset
		else:
			p.global_position = links[-1].global_position + dir.normalized() * projectile_offset
		p.apply_central_impulse(dir.normalized() * projectile_speed)

func change_direction():
	chain_direction = chain_direction * -1
	if chain_direction == -1:
		links[0].is_last_link = true
		links[-1].is_last_link = false
		anchor.global_position = links[-1].global_position
		anchor_joint.set_node_a(links[-1].get_path())
		anchor_joint.set_node_b(anchor.get_path())
#		links[0].fixed = false
#		links[-1].fixed = true
	else:
		links[0].is_last_link = false
		links[-1].is_last_link = true
		anchor.global_position = links[0].global_position
		anchor_joint.set_node_a(anchor.get_path())
		anchor_joint.set_node_b(links[0].get_path())
#		links[0].fixed = true
#		links[-1].fixed = false
	
	camera.global_position = anchor.global_position

func on_enemy_hit():
	for i in range(2):
		add_link(Vector2(0, joint_length))

func on_pickup_touched():
	add_link(Vector2(0, joint_length))
