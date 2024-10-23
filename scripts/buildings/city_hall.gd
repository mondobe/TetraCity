class_name CityHall
extends Node

## Return no bonus
func get_bonus() -> BuildingBonus:
	return BuildingBonus.new()

func get_info_text() -> String:
	return "Handles administrative tasks."
