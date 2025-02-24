extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $MarginContainer/LetterDisplayTimer

@export var MAX_WIDTH := 200

var text = ""
var letter_index = 0

var letter_time = 0.015
var space_time = 0.015
var punctuation_time = 0.015

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	
	label.text = text_to_display
	
	label.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24

	label.text = ""
	display_letter()

func display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
	
func _on_letter_display_timer_timeout() -> void:
	display_letter()
