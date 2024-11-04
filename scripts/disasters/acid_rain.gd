class_name AcidRain
extends Node

const START_DAY: int = 15

const splash_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_splash.tscn")
const clouds_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_clouds.tscn")

var clouds: Sprite2D

func init() -> void:
	clouds = clouds_scene.instantiate()
	add_sibling(clouds)

func get_info_text(day: int) -> String:
	if day < START_DAY:
		var days_left = START_DAY - day
		if days_left <= 10:
			return "Acid rain begins in 10 days!
The top layer of buildings will be melted off!"
		else:
			return ""
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
		if building_grid.building_gets_sun(building):
			rained_on.append(building)

	building_grid.buildings = building_grid.buildings.filter(
		func(building: Building) -> bool:
			return building not in rained_on
	)

	for building: Building in rained_on:
		for x: int in range(building.grid.dimensions.x):
			for y: int in range(building.grid.dimensions.y):
				if building.grid.at(Vector2(x, y)) == 1:
					var splash = splash_scene.instantiate()
					add_sibling(splash)

					var coords = Vector2i(x, y) + building.pos_coords
					var top_corner = building_grid.top_corner_of_space(coords)
					splash.global_position = top_corner

		building.queue_free()

	building_grid.build_grid()
