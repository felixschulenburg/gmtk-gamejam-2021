extends Area2D


signal player_touched


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pickup_body_entered(body):
	if body is Player or body is ChainNode or body is ChainJoint:
		emit_signal("player_touched")
		call_deferred("queue_free")
