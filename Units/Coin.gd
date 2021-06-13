extends Node2D
class_name Coin

onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer

export var coinsPerPickup = 100

signal player_got_coin(coins)

var already_picked_up = false
var rot = 0

func _process(delta):
	rot += delta * 1
	var val = sin(rot) * sin(rot) * 2 - 1
	scale.x = val

func _on_Area2D_body_entered(body):
	if not already_picked_up:
		if body is PlayerJoy or body is PlayerNed:
			already_picked_up = true
			sprite.hide()
			audio.play()
			emit_signal("player_got_coin", coinsPerPickup)
			yield(audio, "finished")
			call_deferred("queue_free")
