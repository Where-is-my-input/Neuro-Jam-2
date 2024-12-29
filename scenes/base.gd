extends Node2D

@export var maxSupply:int = 5
@export var spawnTimer:float = 5.0
@export var teamId:int = 0
@onready var villagers: Node = $villagers
@onready var tmr_spawn: Timer = $tmrSpawn
@onready var lbl_resources: Label = $lblResources
@onready var lbl_supply: Label = $lblSupply
@onready var lbl_team_id: Label = $lblTeamId

var teamColor:Color = Color.WHITE
var resourcesCollected:int = 300

var exploreVectors:Array[Vector2] = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]
var resourceLocations:Array[Area2D] = []
var exploreIndex:int = 0
var exploreRetreatTimer:float = 5.0

const CHARACTER = preload("res://scenes/character.tscn")

func _ready() -> void:
	startSpawnTimer()

func setTeam(id = 0):
	teamId = id
	lbl_team_id.text = str(id)
	var colorMultiplier = 100
	teamColor = Color(255 - teamId * colorMultiplier if teamId % 2 == 0 else 255, 255 - teamId * colorMultiplier if teamId % 3 == 0 else 255, 255 - teamId * colorMultiplier if teamId % 7 == 0 else 255) if teamId > 0 else Color.WHITE
	print("team ", teamId, " - R: ", 255 - teamId * colorMultiplier if teamId % 2 == 0 else 255, "G: ", 255 - teamId * colorMultiplier if teamId % 3 == 0 else 255, "B: ", 255 - teamId * colorMultiplier if teamId % 7 == 0 else 255)

func startSpawnTimer():
	if villagers.get_child_count() < maxSupply && resourcesCollected >= 100:
		tmr_spawn.start(spawnTimer)

func _on_tmr_spawn_timeout() -> void:
	if villagers.get_child_count() < maxSupply && resourcesCollected >= 100:
		resourcesCollected -= 100
		var villager = CHARACTER.instantiate()
		villagers.add_child(villager)
		#villager.set_self_modulate(Color(255 - teamId * 10, 255 - teamId * 10, 255 - teamId * 10))
		villager.setColor(teamColor)
		#villager.exploreDirection = exploreVectors[getExploreIndex()]
		villager.global_position = global_position
		villager.startRetreat()
		updateSupply()
		startSpawnTimer()

func updateSupply():
	lbl_supply.text = str(villagers.get_child_count()) + "/" + str(maxSupply)

func getExploreIndex():
	exploreIndex = exploreIndex + 1 if exploreVectors.size() - 1 > exploreIndex else 0
	return exploreIndex

func addResourcePosition(a:Area2D):
	if !resourceLocations.has(a):
		resourceLocations.push_back(a)

func getNextExploreDirection():#resourceLocations[0] if resourceLocations.size() > 0 else 
	return exploreVectors[getExploreIndex()]

func getNextResource():# && resourceLocations[0] != null
	if resourceLocations.size() > 0:
		var index = randi_range(0,resourceLocations.size() - 1)
		var nextResource = resourceLocations[index]
		if nextResource == null:#!is_instance_valid(nextResource):
			resourceLocations.remove_at(index)
			return null
		return nextResource
	else:
		return null

func retrieveResources(v = 1):
	if v == 0: 
		exploreRetreatTimer += 1.1
	else:
		exploreRetreatTimer = 5.0
	resourcesCollected += v
	lbl_resources.text = str(resourcesCollected)
	if villagers.get_child_count() < maxSupply && resourcesCollected >= 100 && tmr_spawn.is_stopped(): tmr_spawn.start(spawnTimer)
	getMoreSupply()

func supplyFreed():
	tmr_spawn.start(spawnTimer)
	updateSupply()
	if villagers.get_child_count() <= 1:
		queue_free()

func getMoreSupply():
	if resourcesCollected >= 1000 && villagers.get_child_count() >= maxSupply:
		resourcesCollected -= 1000
		maxSupply += 3
		updateSupply()
