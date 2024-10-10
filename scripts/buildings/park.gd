class_name Park
extends Node

## Return a bonus with coins equal to the number of unique adjacent buildings
func get_bonus() -> BuildingBonus:
	return BuildingBonus.new().with_coins(len(get_parent().get_adjacent_buildings()))

func get_info_text() -> String:
	return \
"Earns 1 coin for each adjacent building."
