extends Node

var direction:Vector2
var accept:bool = false
var cancel:bool = false
var base = false
var resource = false
var zoomIn = false
var zoomOut = false

func _physics_process(delta: float) -> void:
	accept = Input.is_action_pressed("ui_accept")
	cancel = Input.is_action_pressed("ui_cancel")
	base = Input.is_action_pressed("base")
	resource = Input.is_action_pressed("resource")
	zoomIn = Input.is_action_pressed("ZoomIn")
	zoomOut = Input.is_action_pressed("ZoomOut")
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
