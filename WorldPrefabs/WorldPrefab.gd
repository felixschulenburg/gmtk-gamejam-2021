extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var entry
var exit


func move_entry_to(node2d):
	global_position = node2d.global_position - entry.global_position
	
# Called when the node enters the scene tree for the first time.
func _ready():
	entry = get_node("Entry")
	exit = get_node("Exit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
