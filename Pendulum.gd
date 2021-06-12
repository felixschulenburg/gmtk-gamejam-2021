extends Node2D
class_name Pendulum

onready var anchor = $Anchor

var ChainLink = preload("ChainLink.tscn")
var ChainJoint = preload("ChainJoint.tscn")
var Projectile = preload("Projectile.tscn")

export var chain_length = 10
export var joint_length = 30

export var projectile_speed = 750
export var projectile_offset = 20

var links = []
var joints = []
	
var dragging
var drag_start = Vector2()

func _ready():
	links.push_back(anchor)
	for i in range(chain_length):
		add_link(Vector2(0, joint_length))

func add_link(offset):
	var new_link = ChainLink.instance()
	add_child(new_link)
	new_link.global_position = links[-1].global_position + offset
	links.push_back(new_link)
	
	var new_joint = ChainJoint.instance()
	links[-1].add_child(new_joint)
	new_joint.set_links(links[-2], links[-1])
	joints.push_back(new_joint)
	
	for i in range(1, links.size()):
		links[i].is_last_link = false
	links[-1].is_last_link = true

func _input(event):
	if event.is_action_pressed("click") and not dragging:
		dragging = true
		drag_start = get_global_mouse_position()
		links[-1].line.show()
	if event.is_action_released("click") and dragging:
		dragging = false
		var drag_end = get_global_mouse_position()
		var dir = links[-1].global_position - drag_end
		shoot(dir)

func shoot(dir):
	for i in range(1, links.size()):
		links[i].apply_central_impulse(-dir)
	links[-1].line.hide()
	
	var p = Projectile.instance()
	add_child(p)
	p.global_position = links[-1].global_position + dir.normalized() * projectile_offset
	p.apply_central_impulse(dir.normalized() * projectile_speed)
