extends Area2D
class_name TouchableZone

signal probe_touchable_succeeded

var player

func on_player_probe_touchable():
	if player and (overlaps_body(player.ned) or overlaps_body(player.joy)):
		emit_signal("probe_touchable_succeeded")
