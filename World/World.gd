extends Node2D

onready var player = $Player
onready var arena = $Arena
onready var menu = $CanvasLayer/PopupMenu

var menu_open = false

func _ready():
	pass

func _on_Player_player_died():
	get_tree().change_scene('res://UI/GameOver.tscn')

func _on_PopupMenu_about_to_show():
	get_tree().paused = true
	menu_open = true

func _on_PopupMenu_popup_hide():
	get_tree().paused = false
	menu_open = false

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_ContinueButton_pressed():
	menu.hide()

func _on_Restart_pressed():
	get_tree().change_scene('res://World/World.tscn')
