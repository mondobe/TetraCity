extends Node

var cutscene_scene: PackedScene = preload("res://scenes/menus/cutscenes.tscn")

var current_cutscene: Cutscene

func load_cutscene(cutscene: Cutscene) -> void:
	current_cutscene = cutscene
	LevelLoader.load_level(cutscene_scene)
