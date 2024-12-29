extends Node2D
const BASE = preload("res://scenes/base.tscn")
const RESOURCE = preload("res://scenes/resource.tscn")
@onready var autotile: Node2D = $autotile

var nextBaseID:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("spawnBase", spawnBase)
	Global.connect("spawnResource", spawnResource)
	autotile.generate()
	#Global.spawnBase.connect(spawnBase)
	#Global.spawnResource.connect(spawnResource)

func spawnBase(coordinates):
	var base = BASE.instantiate()
	add_child(base)
	base.global_position = (coordinates * Vector2(64, 64)) + Vector2(32, 32)
	base.teamId = nextBaseID
	nextBaseID += 1

func spawnResource(coordinates):
	var resource = RESOURCE.instantiate()
	add_child(resource)
	resource.global_position = (coordinates * Vector2(64, 64)) + Vector2(32, 32)