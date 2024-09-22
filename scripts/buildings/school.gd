extends Node



#Return a bonus with coins equal to the number of buildings
func get_bonus() -> BuildingBonus:
	var bonus: int = 0
	var building_grid = get_parent().building_grid;
	if(building_grid != null):
		print("Full")
		for building: Building in building_grid.buildings:
			bonus += 1
	return BuildingBonus.new().with_coins(bonus)
