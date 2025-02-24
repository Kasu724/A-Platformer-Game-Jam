extends Area2D

@onready var sprite := $Sprite2D
@export var locked := false
@export var next_scene : String
var player_nearby := false
var player

func _ready():
	if !locked:
		unlocked()

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("Interact"):
		if !locked:
			enter_door()
		else:
			var carry = player.get_node("Carry")
			if carry.carried_object is Key:
				unlocked()
				var key = carry.carried_object
				carry.drop()
				key.queue_free()

func _on_body_entered(body):
	player = body
	var carry = player.get_node("Carry")
	if locked:
		if carry.carried_object is Key:
			body.get_node("Label").text = "[E] to unlock"
		else:
			body.get_node("Label").text = "Door is locked"
	else:
		body.get_node("Label").text = "[E] to enter"
	player_nearby = true

func _on_body_exited(body):
	body.get_node("Label").text = ""
	player_nearby = false
	player = null

func unlocked():
	sprite.region_rect.position.x -= 16
	locked = false
	
func enter_door():
	var current_scene = get_tree().current_scene.name
	if current_scene.contains("Level"):
		LevelManager.set(current_scene, true)
	var next_scene_path = "res://scenes/levels_and_menus/" + next_scene + ".tscn"
	get_tree().change_scene_to_file(next_scene_path)
	
