extends Node2D

onready var pin_joint = $PinJoint2D
onready var line = $Line2D

export var softness = 0.9

var node_a
var node_b
var connected = false

func _ready():
	pin_joint.softness = 0.9
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	
func _physics_process(delta):
	if connected:
		line.points[0] = to_local(node_a.global_position)
		line.points[1] = to_local(node_b.global_position)

func set_links(_node_a, _node_b):
	node_a = _node_a
	node_b = _node_b
	connected = true
	pin_joint.set_node_a(_node_a.get_path())
	pin_joint.set_node_b(_node_b.get_path())
