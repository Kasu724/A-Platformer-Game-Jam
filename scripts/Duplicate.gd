extends Node

@export var player : CharacterBody2D
@export var carry : Node
@export var time :=  0.05

var timer : float
var dashed := false
var crouched := false
var scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if carry.carrying:
		scene = load(carry.carried_object.scene_file_path)
	
	if timer > 0.0:
		timer -= delta
	
	if carry.carrying and !player.is_crouching and Input.is_action_just_pressed("dash") and carry.carried_object is not Key:
		timer = time
		dashed = true
	
	if dashed:
		if timer > 0.0:
			if Input.is_action_just_pressed("crouch"):
				timer = time
				crouched = true
				dashed = false
		else:
			dashed = false
	
	if crouched:
		if timer > 0.0:
			if Input.is_action_just_pressed("pick_up"):
				dupe()
				crouched = false
		else:
			crouched = false

func dupe():
	var new_object = scene.instantiate()
	#new_object.is_dupe = true
	get_tree().current_scene.add_child(new_object)
	carry.attempt_pick_up(new_object)
