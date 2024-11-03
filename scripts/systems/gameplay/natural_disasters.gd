class_name NaturalDisasters
extends Node

@export var _world_stats: WorldStats

@export var building_grid: BuildingGrid

@export var _disaster_scripts: Array[String]

@onready var disaster: Node = $Disasters

func _ready() -> void:
	init_random_disaster()

func on_new_day() -> void:
	disaster.on_new_day(_world_stats.day)

func get_disaster_info_text() -> void:
	return disaster.get_info_text(_world_stats.day)

func init_random_disaster() -> void:
	var disaster_script_path: String = _disaster_scripts.pick_random()
	var disaster_script: Script = load(disaster_script_path)
	disaster.set_script(disaster_script)
	if disaster.has_method("init"):
		disaster.init()
