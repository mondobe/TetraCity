extends Node

func _on_play_again_button_pressed():
	var titleScreen: PackedScene = load("res://scenes/menus/title_screen.tscn")
	SavedStats.Clear()
	LevelLoader.load_level(titleScreen)
