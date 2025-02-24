extends Button

func _on_pressed() -> void:
	LevelManager.Level1 = false
	LevelManager.Level2 = false
	get_tree().change_scene_to_file("res://scenes/levels_and_menus/main_menu.tscn")
