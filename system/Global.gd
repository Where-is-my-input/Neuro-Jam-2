extends Node

signal spawnResource
signal spawnBase
signal spawnSpikes

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
