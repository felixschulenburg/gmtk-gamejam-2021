extends Node2D
class_name Spike

export var damagePerHit = 5

signal player_hit_by_spike(damage)

func _on_Area2D_body_entered(body):
	if body is Player or body is ChainJoint or body is ChainNode or body is ChainNodeBody:
		emit_signal("player_hit_by_spike", damagePerHit)
