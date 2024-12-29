extends Node

var direction:Vector2
var accept:bool = false
var cancel:bool = false

func _physics_process(delta: float) -> void:
	accept = Input.is_action_pressed("ui_accept")
	cancel = Input.is_action_pressed("ui_cancel")
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
