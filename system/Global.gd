extends Node

signal spawnResource
signal spawnBase
signal spawnSpikes

var seed:String = ""
var size:Vector2 = Vector2(0, 0)
var colors:Array[Color] = [Color.WHITE, Color.BLUE, Color.RED, Color.BLACK, Color.GREEN, Color.YELLOW, Color.CYAN, Color.ORANGE, Color.PURPLE, Color.HOT_PINK]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
