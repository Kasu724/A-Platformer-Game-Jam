extends Node

@export var player : CharacterBody2D
@export var time :=  0.075
@export var boost := 1000.0

var timer : float
var rolled := true
var jumped := false

func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
		
	if player.is_crouching and Input.is_action_just_pressed("dash"):
		timer = time
		rolled = true
	
	if rolled:
		if timer > 0.0:
			if Input.is_action_just_pressed("jump"):
				timer = time
				jumped = true
				rolled = false
		else:
			rolled = false
	
	if jumped:
		if timer > 0.0:
			var direction = 1 if player.animated_sprite.flip_h else -1
			if timer > 0.0 and player.direction == direction * -1:
				player.velocity.x = boost * direction * -1
				jumped = false
		else:
			jumped = false
