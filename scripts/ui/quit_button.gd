class_name QuitButton
extends Button

func _ready() -> void:
	if Settings.demo != 0:
		disabled = true
