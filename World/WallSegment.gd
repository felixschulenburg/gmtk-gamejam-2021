extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var collision_shape = $CollisionShape2D.shape
onready var spawn_area_collision_shape = $SpawnDisableArea/SpawnDisableCollisionArea.shape
onready var spawn_disable_area = $SpawnDisableArea

var spawn_area_extra_extent = 0

# Tracks if this wall segments spawn area currently collides with another spawn area
var has_spawn_area_collision = false


func set_extents(value, spawn_disable_extra_extent=spawn_area_extra_extent):
	spawn_area_extra_extent = spawn_disable_extra_extent
	collision_shape.extents = value
	spawn_area_collision_shape.extents = value + Vector2(spawn_area_extra_extent, spawn_area_extra_extent)
	
func get_extents():
	return collision_shape.extents

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SpawnDisableArea_body_entered(body):
	has_spawn_area_collision = true

func _on_SpawnDisableArea_body_exited(body):
	has_spawn_area_collision = false
