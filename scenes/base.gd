extends Node2D

@export var maxSupply:int = 5
@export var spawnTimer:float = 5.0
@onready var villagers: Node = $villagers
@onready var tmr_spawn: Timer = $tmrSpawn

var resourcesCollected:int = 300

var exploreVectors:Array[Vector2] = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]
var resourceLocations:Array[Area2D] = []
var exploreIndex:int = 0

const CHARACTER = preload("res://scenes/character.tscn")

func _ready() -> void:
	startSpawnTimer()

func startSpawnTimer():
	if villagers.get_child_count() < maxSupply && resourcesCollected >= 100:
		tmr_spawn.start(spawnTimer)
		resourcesCollected -= 100

func _on_tmr_spawn_timeout() -> void:
	var villager = CHARACTER.instantiate()
	villagers.add_child(villager)
	#villager.exploreDirection = exploreVectors[getExploreIndex()]
	villager.global_position = global_position
	villager.startRetreat()
	startSpawnTimer()

func getExploreIndex():
	exploreIndex = exploreIndex + 1 if exploreVectors.size() - 1 > exploreIndex else 0
	return exploreIndex

func addResourcePosition(a:Area2D):
	if !resourceLocations.has(a):
		resourceLocations.push_front(a)

func getNextExploreDirection():#resourceLocations[0] if resourceLocations.size() > 0 else 
	return exploreVectors[getExploreIndex()]

func getNextResource():
	return resourceLocations[0] if resourceLocations.size() > 0 else null

func retrieveResources(v = 1):
	resourcesCollected += v
	if villagers.get_child_count() < maxSupply && resourcesCollected >= 100: tmr_spawn.start(spawnTimer)
