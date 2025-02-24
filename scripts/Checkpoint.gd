extends Node
class_name Checkpoint

@onready var sprite := $Sprite2D
var checked := false
signal set_checkpoint(checkpoint : Checkpoint)

func _on_body_entered(_body: Node2D) -> void:
	if !checked:
		make_green()
		checked = true
		set_checkpoint.emit(self.position)
		

func make_green():
	sprite.region_rect.position.x += 16
