extends Control

@export var nextScene:PackedScene


func _on_ap_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(nextScene)
