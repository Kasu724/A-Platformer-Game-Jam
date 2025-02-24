extends Node2D

@export var speed: float = 120.0  # Speed at which the door retracts
@export var tile_num : int
@export var buttons: Array[Buttons] = []
var is_retracting := false
var startingy : float

func _ready():
	startingy = position.y

func _process(delta):
	if is_retracting:
		if position.y > startingy - ((tile_num - 1) * 16):
			position.y -= speed * delta  # Move upwards
		else:
			is_retracting = false
	else:
		if position.y < startingy - 1:
			position.y += speed * delta
	
	if !buttons.is_empty():
		if buttons.all(func(button): return button.pressed):
			retract()
		else:
			is_retracting = false

func retract():
	is_retracting = true
