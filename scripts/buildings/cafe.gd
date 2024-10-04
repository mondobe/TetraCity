class_name CafeBonus extends Node

## Returns same CPD as the highest CPD from the adjacent buildings
func get_bonus() -> BuildingBonus:
	var adjacent_buildings = get_parent().get_adjacent_buildings()
	var CDP : int = 0
	for building in adjacent_buildings:
		if not building.bonus is CafeBonus and building.bonus.getbonus() > CDP:
			CDP = building.bonus.coins

	return BuildingBonus.new().with_coins(CDP)
