extends Node2D

var Enemy = preload("Enemy.tscn")
var Pickup = preload("Pickup.tscn")

onready var pendulum = $Pendulum

onready var spawn_timer = $SpawnTimer

func _ready():
	spawn_enemy()
	var p = Pickup.instance()
	add_child(p)
	p.global_position = Vector2(randi() % 1000 + 500, randi() % 1000 + 500)
	p.connect("pendulum_touched", pendulum, "on_pickup_touched")
	

func _on_SpawnTimer_timeout():
	spawn_enemy()

func spawn_enemy():
	var position = Vector2(randi() % 500, randi() % 500)
	var e = Enemy.instance()
	add_child(e)
	e.global_position = position
	e.connect("enemy_hit", pendulum, "on_enemy_hit")
	spawn_timer.start()
