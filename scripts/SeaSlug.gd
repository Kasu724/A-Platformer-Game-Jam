extends Area2D

@onready var player := get_parent().get_node("Player")
@onready var sprite := $AnimatedSprite2D

var player_nearby := false
var is_talking := false

@export var lines : Array[String] = []

func _process(_delta: float) -> void:
	if player.position.x < position.x:
		sprite.play("left")
	elif player.position.x > position.x:
		sprite.play("right")
	
	if player_nearby and Input.is_action_just_pressed("Interact"):
		DialogueManager.start_dialogue(global_position, lines)
		

func _on_body_entered(body: Node2D) -> void:
	body.get_node("Label").text = "[E] to talk"
	player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	body.get_node("Label").text = ""
	DialogueManager.stop_dialogue()
	player_nearby = false
