extends Node2D

var title_screen: PackedScene = load('res://scenes/menus/title_screen.tscn')

@export var music_slider: HSlider
@export var sfx_slider: HSlider

func _ready() -> void:
	music_slider.set_value_no_signal(Settings.music_vol)
	sfx_slider.set_value_no_signal(Settings.sfx_vol)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		back_to_title()

func back_to_title() -> void:
	LevelLoader.load_level(title_screen)

func set_music_vol(value: float) -> void:
	Settings.music_vol = value

func set_sfx_vol(value: float) -> void:
	Settings.sfx_vol = value
