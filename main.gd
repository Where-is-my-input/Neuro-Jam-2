extends Node2D
const BASE = preload("res://scenes/base.tscn")
const RESOURCE = preload("res://scenes/resource.tscn")
@onready var autotile: Node2D = $autotile
const SPIKES = preload("res://scenes/spikes.tscn")
var nextBaseID:int = 0
const TEAM_CAVES = preload("res://scenes/team_caves.tscn")
@onready var team_cave_counter: VBoxContainer = $CanvasLayer/teamCaveCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("spawnBase", spawnBase)
	Global.connect("spawnResource", spawnResource)
	Global.connect("spawnSpikes", spawnSpikes)
	autotile.generate()
	#Global.spawnBase.connect(spawnBase)
	#Global.spawnResource.connect(spawnResource)

func spawnBase(coordinates):
	var base = BASE.instantiate()
	add_child(base)
	base.global_position = (coordinates * Vector2(64, 64)) + Vector2(32, 32)
	base.setTeam(nextBaseID)
	var counter = TEAM_CAVES.instantiate()
	team_cave_counter.add_child(counter)
	counter.team.text = str(nextBaseID)
	nextBaseID += 1

func spawnResource(coordinates):
	var resource = RESOURCE.instantiate()
	add_child(resource)
	resource.global_position = (coordinates * Vector2(64, 64)) + Vector2(32, 32)

func spawnSpikes(coordinates = Vector2(0,0)):
	#print(coordinates + Vector2(32, 32))
	var spikes = SPIKES.instantiate()
	add_child(spikes)
	spikes.global_position = coordinates + Vector2(32, 32)

func changeCaveCount(teamId, amount):
	team_cave_counter.get_child(teamId + 1).updateCaves(amount)
