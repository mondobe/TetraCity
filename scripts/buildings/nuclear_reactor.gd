class_name NuclearReactorBonus extends Node

## Give CPD equal to the sum of each neighbor's CPD times 4
func get_bonus() -> BuildingBonus:
	var get_coins_reducer = func(accum, building):
		var bonus = building.bonus
		## Avoid infinite recursion
		if bonus is NuclearReactorBonus:
			return accum
		else:
			return accum + 4 * bonus.get_bonus().coins
	var coins = get_parent().get_adjacent_buildings().reduce(
		get_coins_reducer, 0
	)
	return BuildingBonus.new().with_coins(coins)
