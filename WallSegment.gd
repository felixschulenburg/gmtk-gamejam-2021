extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Vector2) var extents setget set_extents, get_extents
onready var collision_shape = $CollisionShape2D.shape

func set_extents(value):
	collision_shape.extents = value
	
func get_extents():
	return collision_shape.extents

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
