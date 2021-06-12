extends Node2D

signal enemy_hit

func _on_KinematicBody2D_body_entered(body):
	if body is Projectile:
		emit_signal("enemy_hit")
		queue_free()
