extends Node2D

@export var maxSupply:int = 5
@export var spawnTimer:float = 5.0
@onready var villagers: Node = $villagers
@onready var tmr_spawn: Timer = $tmrSpawn

const CHARACTER = preload("res://scenes/character.tscn")

func _ready() -> void:
	startSpawnTimer()

func startSpawnTimer():
	if villagers.get_child_count() < maxSupply:
		tmr_spawn.start(spawnTimer)


func _on_tmr_spawn_timeout() -> void:
	var villager = CHARACTER.instantiate()
	villagers.add_child(villager)
	villager.global_position = global_position
	startSpawnTimer()
