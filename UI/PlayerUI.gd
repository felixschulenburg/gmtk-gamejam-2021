extends Control

var HealthSymbolScene = preload("res://UI/HealthSymbol.tscn")

var health setget set_health, get_health
var health_symbols = []

func set_health(value):
	health = value
	for health_symbol in health_symbols:
		health_symbol.queue_free()
	health_symbols.clear()
	for i in range(health):
		var health_symbol = HealthSymbolScene.instance()
		add_child(health_symbol)
		health_symbol.rect_position = Vector2(32 + i * 64, 32)
		health_symbols.push_back(health_symbol)

func get_health():
	return health

func on_player_health_changed(new_value):
	self.health = new_value
