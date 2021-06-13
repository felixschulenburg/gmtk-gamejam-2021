extends Node2D

onready var label = $CanvasLayer/Label
onready var high_score_label = $CanvasLayer/HighScoreLabel
onready var restart_button = $CanvasLayer/RestartButton
onready var quit_button = $CanvasLayer/QuitButton

func _ready():
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	var center = -transform.origin / scale + get_viewport_rect().size / scale / 2
	label.rect_position = center - label.rect_size / 2
	high_score_label.rect_position = center - high_score_label.rect_size / 2 - Vector2(0, high_score_label.rect_size.y + 128)
	restart_button.rect_position = center - restart_button.rect_size / 2 + Vector2(0, restart_button.rect_size.y + 128)
	quit_button.rect_position = center - quit_button.rect_size / 2 + Vector2(0, quit_button.rect_size.y + 192)

func _on_RestartButton_pressed():
	get_tree().change_scene('res://World/World.tscn')

func _on_QuitButton_pressed():
	get_tree().quit()
