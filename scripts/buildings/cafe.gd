class_name Cafe
extends Node

## Returns same CPD as the highest CPD from the adjacent buildings
func get_bonus() -> BuildingBonus:
	if highest_earner():
		return BuildingBonus.new().with_coins(highest_earner().bonus.get_bonus().coins)
	else:
		return BuildingBonus.new()

func highest_earner() -> Building:
	var adjacent_buildings = get_parent().get_adjacent_buildings()
	var coins: int = 0
	var highest_earner: Building = null
	for building: Node in adjacent_buildings:
		var bonus: BuildingBonus = building.bonus.get_bonus()
		if bonus.coins > coins and not building.bonus is Cafe:
			coins = bonus.coins
			highest_earner = building
	return highest_earner

func get_info_text() -> String:
	var highest_earner = highest_earner()
	if highest_earner == null:
		return \
"Earns the same income as the highest-earning adjacent building each day (excluding other Cafes)."
	else:
		return \
"Earns the same income as the highest-earning adjacent building each day (excluding other Cafes).
Right now, that's the %s with %d coins." % [
	highest_earner.variation.building_name,
	highest_earner.bonus.get_bonus().coins
]
