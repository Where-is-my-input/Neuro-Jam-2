extends Node2D
@onready var vc:Node = $virtual_controller

const tile_size = 64
var moving:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size

func _physics_process(delta: float) -> void:
	if vc.direction && !moving:
		move(vc.direction)
		#animate(vc.direction)

func move(dir: Vector2):
	var moveTo = Vector2(dir.x, 0) if dir.x else Vector2(0, dir.y)
	#position += dir * tile_size
	var tween = create_tween()
	tween.tween_property(self, "position", position + moveTo * tile_size, 0.2).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
