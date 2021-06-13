extends Node2D
class_name Pickup

onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer

export var healthPerPickup = 1

signal player_picked_up(segments)

var already_picked_up = false

func _on_Area2D_body_entered(body):
	if not already_picked_up:
		if body is PlayerJoy or body is PlayerNed:
			already_picked_up = true
			sprite.hide()
			audio.play()
			emit_signal("player_picked_up", healthPerPickup)
			yield(audio, "finished")
			call_deferred("queue_free")
