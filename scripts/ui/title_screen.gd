extends Node2D

@export var _opening_cutscene: Cutscene
const _setting_scene = preload("res://scenes/menus/settings.tscn")
const _credits_scene = preload("res://scenes/menus/credits.tscn")

func _on_setting_button_pressed():
	LevelLoader.load_level(_setting_scene)

func _on_credits_button_pressed():
	LevelLoader.load_level(_credits_scene)


func _on_start_button_pressed():
	CutsceneLoader.load_cutscene(_opening_cutscene)

func _on_quit_button_pressed():
	get_tree().quit()
