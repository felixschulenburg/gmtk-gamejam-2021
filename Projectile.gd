extends RigidBody2D
class_name Projectile

onready var timer = $Timer

func _ready():
	timer.start()

func _on_Timer_timeout():
	queue_free()
