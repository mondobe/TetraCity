class_name NaturalDisasters
extends Node

@export var _world_stats: WorldStats

@export var building_grid: BuildingGrid

@export var warning_box: DialogueBox

@export var _disaster_scripts: Array[String]

@onready var disaster: Node = $Disasters

func _ready() -> void:
	init_random_disaster()
	warning_box.resize_borders(Vector2i(150, 150))

func on_new_day() -> void:
	if not disaster:
		disaster = $Disasters
		init_random_disaster()
	disaster.on_new_day(_world_stats.day)
	var info: String = disaster.get_info_text(_world_stats.day)
	if info.is_empty():
		warning_box.hide()
	else:
		warning_box.show()
		warning_box.set_text(info)
		warning_box.set_border_width(150)

func get_disaster_info_text() -> void:
	return disaster.get_info_text(_world_stats.day)

func init_random_disaster() -> void:
	var disaster_script_path: String = _disaster_scripts.pick_random()
	var disaster_script: Script = load(disaster_script_path)
	disaster.set_script(disaster_script)
	if disaster.has_method("init"):
		disaster.init(_world_stats)
	SavedStats.setNaturalDisaster(disaster.disaster_name)
