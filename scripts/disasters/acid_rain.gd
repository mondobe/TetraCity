class_name AcidRain
extends Node

const START_DAY: int = 15

func init() -> void:
	print("Hello from acid rain")

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
	if day == START_DAY:
		acid_rain()

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
		building.queue_free()

	building_grid.build_grid()
