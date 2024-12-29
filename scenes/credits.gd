extends Control
@onready var timer: Timer = $Timer

func _input(event: InputEvent) -> void:
	if timer.is_stopped():
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
