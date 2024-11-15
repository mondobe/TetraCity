extends Node2D

const _main_scene = preload("res://scenes/gameplay/world.tscn")
const _setting_scene = preload("res://scenes/menus/settings.tscn")

func _on_setting_button_pressed():
	LevelLoader.load_level(_setting_scene)


func _on_start_button_pressed():
	SavedStats.Clear()
	LevelLoader.load_level(_main_scene)


func _on_quit_button_pressed():
	get_tree().quit()
