class_name CityHall
extends Node

## Return no bonus
func get_bonus() -> BuildingBonus:
	return BuildingBonus.new()
