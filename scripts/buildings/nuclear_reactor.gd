class_name NuclearReactor extends Node

## Give CPD equal to the sum of each neighbor's CPD times 4
func get_bonus() -> BuildingBonus:
	var get_coins_reducer = func(accum, building):
		var bonus = building.bonus
		## Avoid infinite recursion
		if bonus is NuclearReactor or bonus is Cafe:
			return accum
		else:
			return accum + 4 * bonus.get_bonus().coins
	var coins = get_parent().get_adjacent_buildings().reduce(
		get_coins_reducer, 0
	)
	return BuildingBonus.new().with_coins(coins)

func get_info_text() -> String:
	return "Supercharges all nearby buildings, causing them to make 5 times as much money!"
