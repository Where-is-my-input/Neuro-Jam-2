extends Node2D

var amount:int = 500
@onready var lbl_amount: Label = $lblAmount

func _ready() -> void:
	amount = randi_range(250, 750)
	lbl_amount.text = str(amount)

func removeResource(v = 1):
	amount -= v
	lbl_amount.text = str(amount)
	if amount <= 0:
		queue_free()
