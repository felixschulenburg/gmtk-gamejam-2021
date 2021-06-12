extends Node2D

var Enemy = preload("Enemy.tscn")

onready var pendulum = $Pendulum

onready var spawn_timer = $SpawnTimer

func _ready():
	spawn_enemy()

func _on_SpawnTimer_timeout():
	spawn_enemy()

func spawn_enemy():
	var position = Vector2(randi() % 500, randi() % 500)
	var e = Enemy.instance()
	add_child(e)
	e.global_position = position
	e.connect("enemy_hit", pendulum, "on_enemy_hit")
	spawn_timer.start()
