class_name SolarFarm
extends Node

func get_bonus() -> BuildingBonus:
	var building: Building = get_parent()
	var building_grid: BuildingGrid = building.building_grid

	# Only add fuel if the day is a multiple of 3 (for balance reasons)
	if building_grid.world_stats.day % 3 == 0 and building_grid.building_gets_sun(building):
		return BuildingBonus.new().with_fuel(1)
	return BuildingBonus.new()


func get_info_text() -> String:
	var building: Building = get_parent()
	var building_grid: BuildingGrid = building.building_grid
	var next_payout_day = 3 - get_parent().building_grid.world_stats.day % 3
	return "Gives one day's worth of fuel every 3 days as long as this building \
isn't blocked by others above it.
%s" % (("(Next payout in %d days)" % next_payout_day)
		if building_grid.building_gets_sun(building)
		else "This building is blocked, so it doesn't produce fuel.")
