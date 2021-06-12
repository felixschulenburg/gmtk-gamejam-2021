extends RigidBody2D
class_name Link

onready var line = $Line2D

var is_last_link = false setget set_is_last_link

func _ready():
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	line.hide()

func _process(delta):
	if self.is_last_link:
		line.points[0] = to_local(global_position)
		line.points[1] = to_local(get_global_mouse_position())

func set_is_last_link(_is_last_link):
	is_last_link = _is_last_link
