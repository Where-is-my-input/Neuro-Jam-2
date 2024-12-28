extends CharacterBody2D

const SPEED = 300.0

var resource:Area2D = null
@onready var nav: NavigationAgent2D = $nav
@onready var tmr_retreat: Timer = $tmrRetreat

var retreating:bool = false
var collecting:bool = false
var resourceCollected:int = 0
@export var maxResource:int = 25
@export var exploreDirection:Vector2 = Vector2(1,0)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	var direction = exploreDirection
	if resource != null && resourceCollected < maxResource:
		nav.target_position = resource.global_position
		var targetPosition = nav.get_next_path_position()
		direction = global_position.direction_to(targetPosition) if !nav.is_target_reached() else Vector2(0,0)
	elif resourceCollected >= maxResource || retreating:
		nav.target_position = get_parent().get_parent().global_position
		var targetPosition = nav.get_next_path_position()
		direction = global_position.direction_to(targetPosition) if !nav.is_target_reached() else Vector2(0,0)
	if direction: # && (resourceCollected < maxResource || resource == null)
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
		if resource && collecting:
			resourceCollected += 1

	move_and_slide()

func startRetreat(v = randf_range(5, 25)):
	tmr_retreat.start(v)

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("resource"):
		resource = area
func _on_tmr_retreat_timeout() -> void:
	if resource == null: retreating = true

func _on_retreat_area_entered(area: Area2D) -> void:
	if area.is_in_group("resource"):
		resource = area
		collecting = true
	if area.is_in_group("base"):
		var base = area.get_parent()
		if resource != null: base.addResourcePosition(resource)
		base.retrieveResources(resourceCollected)
		resourceCollected = 0
		retreating = false
		exploreDirection = base.getNextExploreDirection()
		resource = base.getNextResource()
		startRetreat()

func _on_retreat_area_exited(area: Area2D) -> void:
	if area.is_in_group("resource"):
		collecting = false
