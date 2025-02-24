extends Node

var retractable
# Called when the node enters the scene tree for the first time.
func _ready():
	retractable = get_node("WoodRetractable5")
	if LevelManager.Level1:
		get_node("Player").position = Vector2(77, -15)
	if LevelManager.Level2:
		get_node("Player").position = Vector2(422, -15)

func _process(_delta) -> void:
	if LevelManager.Level1:
		retractable.retract()
