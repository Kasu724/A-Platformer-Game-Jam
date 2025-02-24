extends Node

@export var player : CharacterBody2D
@export var right_ray : RayCast2D
@export var left_ray : RayCast2D

var carrying := false
var carried_object: Moveable = null
var carry_offset := Vector2(0, -17)
var carry_offset_crouch := Vector2(0,-9)
var collision: CollisionShape2D = null

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("pick_up"):
		if carrying:
			attempt_drop()
		else:
			if right_ray.is_colliding() and !player.animated_sprite.flip_h and right_ray.get_collider() is Moveable:
				attempt_pick_up(right_ray.get_collider())
			elif left_ray.is_colliding() and player.animated_sprite.flip_h and left_ray.get_collider() is Moveable:
				attempt_pick_up(left_ray.get_collider())
			
	if carrying:
		if player.is_crouching:
			carried_object.position = player.position + carry_offset_crouch
			collision.position.y = carry_offset_crouch.y
			adjust_raycast_positions(-17)
		else:
			carried_object.position = player.position + carry_offset
			collision.position.y = carry_offset.y
			adjust_raycast_positions(0)

func attempt_pick_up(object: Moveable):
	var check_position = carry_offset
	var check_position_crouch = carry_offset_crouch
	
	# Create a ShapeCast2D to detect space above the player
	var shape_cast = ShapeCast2D.new()
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(4, 7)
	shape_cast.shape = rect
	shape_cast.position = check_position if player.is_crouching == false else check_position_crouch
	shape_cast.target_position = Vector2(0, 0)  # Static check
	shape_cast.set_collision_mask_value(2, true)
	player.add_child(shape_cast)
	shape_cast.force_shapecast_update()
	
	# If it collides, check if crouching provides enough space
	if shape_cast.is_colliding():
		player.remove_child(shape_cast)
		shape_cast.queue_free()
		return

	# Enough space was found
	player.remove_child(shape_cast)
	shape_cast.queue_free()
	pick_up(object)

func pick_up(object : Moveable):
	carrying = true
	carried_object = object
	
	carried_object.set_physics_process(false)
	for child in carried_object.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
	collision = CollisionShape2D.new()
	var original_shape = carried_object.get_node("CollisionShape2D").shape.duplicate()  # Copy shape
	collision.shape = original_shape
	collision.position = carry_offset  # Position it on top of player

	player.add_child(collision)
	
func attempt_drop():
	var shape_cast = ShapeCast2D.new()
	var direction = -1 if player.animated_sprite.flip_h else 1
	var drop_offset = Vector2(10 * direction, 4)
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(3, 5)
	shape_cast.shape = rect
	shape_cast.position = drop_offset
	shape_cast.target_position = Vector2(0, 0)
	shape_cast.set_collision_mask_value(2, true)
	player.add_child(shape_cast)
	shape_cast.force_shapecast_update()
	
	if shape_cast.is_colliding():
		player.remove_child(shape_cast)
		shape_cast.queue_free()
		return
		
	player.remove_child(shape_cast)
	shape_cast.queue_free()
	drop()

func drop():
	carrying = false
	
	if carried_object:
		carried_object.set_physics_process(true)
		
		for child in carried_object.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", false)
				
		if collision:
			collision.queue_free()
			collision = null
				
		var direction = -1 if player.animated_sprite.flip_h else 1
		var drop_offset = Vector2(15 * direction, 5)
		carried_object.global_position = player.global_position + drop_offset
		
		adjust_raycast_positions(0)
					
		carried_object.velocity = player.velocity
		
		carried_object = null

func adjust_raycast_positions(offset: float):
	for child in player.get_children():
		if child.name == "RayCast2D 1" or child.name == "RayCast2D 2":
			child.position.y = offset
