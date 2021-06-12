extends PopupMenu

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not visible:
			popup()
		else:
			hide()
