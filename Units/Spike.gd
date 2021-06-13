extends Node2D
class_name Spike

export var damagePerHit = 1

signal player_joy_hit_by_spike(damage)
signal player_ned_hit_by_spike(damage)

func _on_Area2D_body_entered(body):
#	if body is Player or body is ChainJoint or body is ChainNode or body is ChainNodeBody:
	if body is PlayerJoy:
		emit_signal("player_joy_hit_by_spike", damagePerHit)
	elif body is PlayerNed:
		emit_signal("player_ned_hit_by_spike", damagePerHit)
