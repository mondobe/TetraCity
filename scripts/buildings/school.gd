extends Node



#Return a bonus with coins equal to the number of buildings
func get_bonus() -> BuildingBonus:
	var bonus: int = 0
	var building_grid = get_parent().building_grid;
	if(building_grid != null):
		bonus += building_grid.buildings.size();
	return BuildingBonus.new().with_coins(bonus)
