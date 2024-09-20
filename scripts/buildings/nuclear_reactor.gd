extends Node

## Multiply adjacent coin bonuses by five, by adding four times their CPD
func get_bonus() -> BuildingBonus:
	var coins = get_parent().get_adjacent_buildings().reduce(
		func(accum, building) : return 4 * building.bonus.coins
	)
	return BuildingBonus.new().with_coins(coins)
