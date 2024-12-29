extends Control
@onready var btnPlay: Button = $vBox/play

@export var play:PackedScene
@export var options:PackedScene
@export var credits:PackedScene

func _ready() -> void:
	btnPlay.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_packed(options)
	
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(credits)
