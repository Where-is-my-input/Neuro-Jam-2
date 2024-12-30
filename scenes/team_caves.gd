extends HBoxContainer
@onready var caves: Label = $caves
@onready var team: Label = $team

var caveCount:int = 1

func updateCaves(amount = 1):
	caveCount += amount
	caves.text = str(caveCount)
