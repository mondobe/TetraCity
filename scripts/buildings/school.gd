extends Node

# Return a bonus with coins equal to the number of buildings
func get_bonus() -> BuildingBonus:
	var bonus: int = 0
	var building_grid: BuildingGrid = get_parent().building_grid;
	if building_grid.world_stats.day % 5 == 0:
		bonus += building_grid.buildings.size();
	return BuildingBonus.new().with_coins(bonus)

func get_info_text() -> String:
	var next_payout_day = 5 - get_parent().building_grid.world_stats.day % 5
	return "Every 5 days, earns one coin for every single building in the city.
(Next payout in %d days)" % next_payout_day
