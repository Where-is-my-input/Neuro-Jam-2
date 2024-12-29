extends Node

var direction:Vector2

func _physics_process(delta: float) -> void:
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
