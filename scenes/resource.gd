extends Node2D

var amount:int = 500

func removeResource(v = 1):
	amount -= v
	if amount <= 0:
		queue_free()
