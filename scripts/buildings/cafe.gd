class_name Cafe
extends Node

## Returns same CPD as the highest CPD from the adjacent buildings
func get_bonus() -> BuildingBonus:
	var adjacent_buildings = get_parent().get_adjacent_buildings()
	var coins: int = 0
	for building: Node in adjacent_buildings:
		var bonus: BuildingBonus = building.bonus.get_bonus()
		if bonus.coins > coins and not building.bonus is Cafe:
			coins = bonus.coins

	return BuildingBonus.new().with_coins(coins)
