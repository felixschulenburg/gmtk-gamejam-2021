extends Node2D
class_name Enemy

signal enemy_hit

func _on_KinematicBody2D_body_entered(body):
	if body is Projectile:
		emit_signal("enemy_hit")
		call_deferred("queue_free")
