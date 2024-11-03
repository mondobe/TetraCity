extends Node2D

var title_screen: PackedScene = load('res://scenes/menus/title_screen.tscn')

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		back_to_title()

func back_to_title() -> void:
	LevelLoader.load_level(title_screen)
