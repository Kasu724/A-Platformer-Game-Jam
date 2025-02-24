extends Node

@export var player : CharacterBody2D
var checkpoint : Vector2

signal reset_all

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	checkpoint = player.position
	for point in get_tree().get_nodes_in_group("Checkpoints"):
		point.set_checkpoint.connect(set_checkpoint)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Reset"):
		reset()

func reset():
	player.position = checkpoint
	player.velocity = Vector2.ZERO
	reset_all.emit()
	
func set_checkpoint(new_checkpoint : Vector2):
	checkpoint = new_checkpoint
