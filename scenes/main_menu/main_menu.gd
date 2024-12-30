extends Control
@onready var btnPlay: Button = $vBox/play
@onready var line_x: LineEdit = $vBox/HBoxContainer/lineX
@onready var line_y: LineEdit = $vBox/HBoxContainer/lineY
@onready var h_box_container: HBoxContainer = $vBox/HBoxContainer
@onready var seed: LineEdit = $vBox/HBoxContainer/seed

@export var play:PackedScene
@export var options:PackedScene
@export var credits:PackedScene

func _ready() -> void:
	btnPlay.grab_focus()
	line_x.text = str(Global.size.x)
	line_y.text = str(Global.size.y)
	seed.text = Global.seed

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_packed(options)
	
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(credits)


func _on_line_x_text_changed(new_text: String) -> void:
	Global.size.x = new_text.to_int()


func _on_line_y_text_changed(new_text: String) -> void:
	Global.size.y = new_text.to_int()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("base"):
		h_box_container.visible = !h_box_container.visible

func _on_seed_text_changed(new_text: String) -> void:
	Global.seed = new_text
