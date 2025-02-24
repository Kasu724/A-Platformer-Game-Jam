extends CharacterBody2D

class_name Moveable

@onready var player_ray_l: RayCast2D = $Left
@onready var player_ray_r: RayCast2D = $Right
@onready var player_ray_below_l: RayCast2D = $PlayerBelowL
@onready var player_ray_below_m: RayCast2D = $PlayerBelowM
@onready var player_ray_below_r: RayCast2D = $PlayerBelowR

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var ignore_collision = false

var origin : Vector2

func _ready():
	origin = position
	var reset = get_tree().current_scene.get_node("Player/Reset")
	reset.reset_all.connect(reset_object)

func _physics_process(delta: float) -> void:
	
	if player_ray_below_l.is_colliding() or player_ray_below_m.is_colliding() or player_ray_below_r.is_colliding():
		ignore_collision = true
	else:
		ignore_collision = false
	
	if _contact():
		var collision
		if player_ray_r.is_colliding():
			collision = player_ray_r.get_collider()
			if collision.direction == -1:
				velocity.x = collision.PUSH_FORCE * collision.direction
		else:
			collision = player_ray_l.get_collider()
			if collision.direction == 1:
				velocity.x = collision.PUSH_FORCE * collision.direction
	
	else:
		velocity.x = move_toward(velocity.x, 0.0, 10)

	if !ignore_collision:
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _contact() -> bool:
	return player_ray_r.is_colliding() or player_ray_l.is_colliding()
	
func reset_object():
	position = origin
