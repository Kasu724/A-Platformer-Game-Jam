extends Node

@export var player : CharacterBody2D
@export var carry : Node

var lag := 0.05
var timer : float
var clip := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
	var direction = -1 if player.animated_sprite.flip_h else 1
	if carry.carrying and player.is_on_wall() and player.is_on_floor() and player.is_crouching:
		if Input.is_action_just_pressed("dash"):
			var shape_cast = ShapeCast2D.new()
			var position = Vector2(32 * direction, -4.0)
			var rect = RectangleShape2D.new()
			rect.extents = Vector2(7, 15)
			shape_cast.shape = rect
			shape_cast.position = position
			shape_cast.target_position = Vector2(0, 0)
			shape_cast.set_collision_mask_value(2, true)
			player.add_child(shape_cast)
			shape_cast.force_shapecast_update()
			
			if !shape_cast.is_colliding():
				timer = lag
				player.position.x += 15 * direction
				clip = true
			
			player.remove_child(shape_cast)
			shape_cast.queue_free()
				
	if timer <= 0.0 and clip == true:
		clip = false
		player.position.x += 10 * direction
