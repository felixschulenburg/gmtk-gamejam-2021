extends Node2D
class_name Pickup

export var healthPerPickup = 1

signal player_picked_up(segments)

var already_picked_up = false

func _on_Area2D_body_entered(body):
	if not already_picked_up:
		if body is PlayerJoy or body is PlayerNed:
			emit_signal("player_picked_up", healthPerPickup)
			already_picked_up = true
			call_deferred("queue_free")
