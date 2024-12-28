extends CharacterBody2D

const SPEED = 300.0

var resource:Area2D = null

var resourceCollected:int = 0
@export var maxResource:int = 25

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if direction && (resourceCollected < maxResource || resource == null):
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
		if resource:
			resourceCollected += 1

	move_and_slide()

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("resource"):
		resource = area
