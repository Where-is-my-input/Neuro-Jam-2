extends CharacterBody2D

const SPEED = 300.0
@onready var spr: AnimatedSprite2D = $spr
@onready var lbl_teamid: Label = $lblTeamid
@onready var audio_hit: AudioStreamPlayer2D = $audioHit

var resource:Area2D = null
var enemy:CharacterBody2D = null
@onready var nav: NavigationAgent2D = $nav
@onready var tmr_retreat: Timer = $tmrRetreat
@onready var tmr_attack: Timer = $tmrAttack
@onready var hp: ProgressBar = $HP

var retreating:bool = false
var collecting:bool = false
var attacking:bool = false
var resourceCollected:int = 0
@export var maxResource:int = 25
@export var exploreDirection:Vector2 = Vector2(1,0)
@export var maxHP:int = 25
@export var attackDamage:int = 5

func _ready() -> void:
	hp.value = maxHP

func _physics_process(delta: float) -> void:
	var targetPosition = null
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	var direction = exploreDirection
	if enemy != null:
		nav.target_position = enemy.global_position
		targetPosition = nav.get_next_path_position()
		#direction = global_position.direction_to(targetPosition) if !nav.is_target_reached() else Vector2(0,0)
	elif resource != null && resourceCollected < maxResource:
		nav.target_position = resource.global_position
		targetPosition = nav.get_next_path_position()
		#direction = global_position.direction_to(targetPosition) if !nav.is_target_reached() else Vector2(0,0)
	elif resourceCollected >= maxResource || retreating:
		nav.target_position = get_parent().get_parent().global_position
		targetPosition = nav.get_next_path_position()
	if targetPosition != null: 
		if !nav.is_target_reached():
			direction = global_position.direction_to(targetPosition)
		elif enemy != null:
			attacking = true
		else:
			direction = Vector2(0,0)
			#direction = global_position.direction_to(targetPosition) if !nav.is_target_reached() else Vector2(0,0)
	if direction && !attacking: # && (resourceCollected < maxResource || resource == null)
		velocity = direction * SPEED
		setAnimation(direction)
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
		if resource && collecting && !attacking:
			resourceCollected += 1
			if resourceCollected >= maxResource:
				resource.get_parent().removeResource(resourceCollected)

	if move_and_slide():
		exploreDirection = Vector2(randi_range(-1, 1), randi_range(-1, 1))

func startRetreat(v = randf_range(5, 25)):
	tmr_retreat.start(v)

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("resource"):
		resource = area
func _on_tmr_retreat_timeout() -> void:
	if resource == null && !attacking: retreating = !retreating

func _on_retreat_area_entered(area: Area2D) -> void:
	if area.is_in_group("resource"):
		resource = area
		collecting = true
	if area.is_in_group("base"):
		var base = area.get_parent()
		if base.teamId != get_parent().get_parent().teamId: return
		if resource != null: base.addResourcePosition(resource)
		base.retrieveResources(resourceCollected)
		resourceCollected = 0
		retreating = false
		exploreDirection = base.getNextExploreDirection()
		resource = base.getNextResource()
		startRetreat(base.exploreRetreatTimer)

func _on_retreat_area_exited(area: Area2D) -> void:
	if area.is_in_group("resource"):
		collecting = false

func _on_detection_body_entered(body) -> void:
	if body.is_in_group("villager"):
		if body.get_parent().get_parent().teamId == get_parent().get_parent().teamId: return
		enemy = body
		tmr_attack.start(1)

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("villager"):
		if body.get_parent().get_parent().teamId == get_parent().get_parent().teamId: return
		attacking = false
		enemy = null


func _on_tmr_attack_timeout() -> void:
	if enemy != null:
		enemy.getHit(attackDamage)
		tmr_attack.start(1)

func getHit(d = 1):
	audio_hit.play()
	hp.value -= d
	if hp.value <= 0:
		get_parent().get_parent().supplyFreed()
		queue_free()

func setColor(color:Color):
	var index = 0
	#spr.modulate = color
	var materialArray = ["shader_parameter/newColor1","shader_parameter/newColor2","shader_parameter/newColor3"]
	for m in materialArray:
		#var r = paletteArray[index].r
		#var g = paletteArray[index].g
		#var b = paletteArray[index].b
		index += 1
		material.set(m, color)
		if get_parent().get_parent().teamId < 10 && index > 0 || get_parent().get_parent().teamId < 20 && index > 1:
			break
	lbl_teamid.text = str(get_parent().get_parent().teamId)

func setAnimation(dir):
	if dir.x > 0: spr.play("right")
	if dir.x < 0: spr.play("left")
	if dir.y > 0: spr.play("down")
	if dir.y < 0: spr.play("up")
	#match dir.y:
		#1:
			#spr.play("down")
		#-1:
			#spr.play("up")
