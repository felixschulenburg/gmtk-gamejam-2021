extends Node2D

func _on_KinematicBody2D_body_entered(body):
	if body is Projectile:
		queue_free()
