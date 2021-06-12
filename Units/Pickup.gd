extends Node2D
class_name Pickup

export var segmentsPerPickup = 5

signal player_picked_up(segments)

var already_picked_up = false

func _on_Area2D_body_entered(body):
	if not already_picked_up:
		if body is Player or body is ChainNode or body is ChainJoint or body is ChainNodeBody:
			emit_signal("player_picked_up", segmentsPerPickup)
			already_picked_up = true
			call_deferred("queue_free")
