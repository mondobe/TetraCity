class_name AcidRain
extends Node

const START_DAY: int = 45

const splash_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_splash.tscn")
const clouds_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_clouds.tscn")

var clouds: Sprite2D

var _world_stats: WorldStats

var disaster_name = "Acid Rain"

func init(world_stats: WorldStats) -> void:
	clouds = clouds_scene.instantiate()
	_world_stats = world_stats
	add_sibling(clouds)

func get_info_text(day: int) -> String:
	if day < START_DAY - 1:
		var days_left = START_DAY - day
		if days_left <= 10 and days_left > 0:
			return "Acid rain begins in %d days!
The top layer of buildings will be melted off!" % days_left
		else:
			return ""
	elif day == START_DAY - 1:
			return "Acid rain begins tomorrow!
The top layer of buildings will be melted off!"
	elif day == START_DAY:
		return "Watch out for acid rain today!"
	else:
		return ""

func on_new_day(day: int) -> void:
	if day <= START_DAY:
		var intensity: float = max((day + 5 - START_DAY) * 0.2, 0)
		clouds.self_modulate = Color(1, 1, 1, intensity)

		if day == START_DAY:
			acid_rain()
	else:
		clouds.self_modulate = Color(1, 1, 1, 0)

func acid_rain() -> void:
	var building_grid: BuildingGrid = get_parent().building_grid
	var rained_on: Array[Building]

	for building: Building in building_grid.buildings:
		if (not building.bonus is CityHall) and building_grid.building_gets_sun(building):
			rained_on.append(building)

	building_grid.destroy_buildings(rained_on, splash_scene)
