extends Control

var HealthSymbolScene = preload("res://UI/HealthSymbol.tscn")

onready var score_label = $ScoreLabel

var joy_health setget set_joy_health, get_joy_health
var ned_health setget set_ned_health, get_ned_health
var joy_health_symbols = []
var ned_health_symbols = []

var score setget set_score, get_score

func set_joy_health(value):
	joy_health = value
	for health_symbol in joy_health_symbols:
		health_symbol.queue_free()
	joy_health_symbols.clear()
	for i in range(joy_health):
		var health_symbol = HealthSymbolScene.instance()
		add_child(health_symbol)
		health_symbol.rect_position = Vector2(32 + i * 64, 32)
		health_symbol.texture = load("res://Assets/heart_blue.png")
		joy_health_symbols.push_back(health_symbol)

func set_ned_health(value):
	ned_health = value
	for health_symbol in ned_health_symbols:
		health_symbol.queue_free()
	ned_health_symbols.clear()
	for i in range(ned_health):
		var health_symbol = HealthSymbolScene.instance()
		add_child(health_symbol)
		health_symbol.rect_position = Vector2(32 + i * 64, 96)
		health_symbol.texture = load("res://Assets/heart_orange.png")
		ned_health_symbols.push_back(health_symbol)

func get_joy_health():
	return joy_health

func get_ned_health():
	return joy_health

func set_score(value):
	score = value
	score_label.set_text("Score: " + str(score))

func get_score():
	return score
