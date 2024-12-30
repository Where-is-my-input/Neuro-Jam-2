extends Node2D
@onready var vc:Node = $virtual_controller
@onready var tmr_delay: Timer = $tmrDelay
@onready var collision_shape_2d: CollisionShape2D = $areaDelete/CollisionShape2D
@onready var cam: Camera2D = $Camera2D

const tile_size = 64
var moving:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size

func _physics_process(delta: float) -> void:
	if vc.zoomIn:
		print("zoom int")
		cam.zoom += Vector2(0.1, 0.1)
	elif vc.zoomOut:
		cam.zoom -= Vector2(0.1, 0.1)
	if !moving:
		if vc.direction:
			move(vc.direction)
			#animate(vc.direction)
		if tmr_delay.is_stopped():
			if vc.accept:
				tmr_delay.start(0.5)
				Global.spawnSpikes.emit(global_position)
			if vc.base:
				tmr_delay.start(0.5)
				Global.spawnBase.emit(global_position / Vector2(64, 64))
			if vc.resource:
				tmr_delay.start(0.5)
				Global.spawnResource.emit(global_position / Vector2(64, 64))
			if vc.cancel:
				collision_shape_2d.set_deferred("disabled", false)
			else:
				collision_shape_2d.set_deferred("disabled", true)

func move(dir: Vector2):
	var moveTo = Vector2(dir.x, 0) if dir.x else Vector2(0, dir.y)
	#position += dir * tile_size
	var tween = create_tween()
	tween.tween_property(self, "position", position + moveTo * tile_size, 0.2).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false


func _on_area_delete_area_entered(area: Area2D) -> void:
	if area.is_in_group("spike"):
		area.queue_free()
	if area.is_in_group("base") || area.is_in_group("resource"):
		area.get_parent().queue_free()
