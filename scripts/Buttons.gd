extends StaticBody2D

class_name Buttons

var pressed := false
@export var sticky := false
@onready var sprite := $Sprite2D
@onready var top_col := $CollisionShape2D2
@onready var area2d := $Area2D

func _on_body_entered(_body):
	if !pressed:
		sprite.region_rect.position.y += 16
		var shape = top_col.shape as RectangleShape2D
		shape.size.y = 2
		top_col.position.y += 2
		pressed = true

func _on_body_exited(_body: Node2D) -> void:
	if pressed and not sticky:
		sprite.region_rect.position.y -= 16
		var shape = top_col.shape as RectangleShape2D
		shape.size.y = 5
		top_col.position.y -= 2
		pressed = false
