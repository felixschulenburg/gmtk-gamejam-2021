extends Node2D
class_name ChainJoint

onready var joint = $Joint2D
onready var line = $Line2D

var node_a
var node_b
var connected = false

func _ready():
	joint.softness = 0.5
#	joint.length = 1
#	joint.rest_length = 0
#	joint.stiffness = 64.0
#	joint.damping = 0.0
#	joint.bias = 10.0
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	
func _physics_process(delta):
	if connected:
		line.points[0] = to_local(node_a.global_position)
		line.points[1] = to_local(node_b.global_position)

func set_nodes(_node_a, _node_b):
	node_a = _node_a
	node_b = _node_b
	connected = true
	joint.set_node_a(_node_a.get_path())
	joint.set_node_b(_node_b.get_path())
