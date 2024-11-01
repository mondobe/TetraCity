class_name Bank
extends Node

func get_bonus() -> BuildingBonus:
	return BuildingBonus.new()

# Count the number of adjacent buildings matching the type of the blueprint parameter 
# and calculate the appropriate modifier
func get_scale_factor(bd_print: BuildingBlueprint) -> float:
	var adjust_factor: float = 0.75
	var match_cnt = get_parent().get_adjacent_buildings().reduce(
		func(acc, building): 
			# I'm assuming equality works here, possibly change later
			var matches_type = building.blueprint == bd_print
			acc + 1 if matches_type else acc
	, 0)
	return pow(adjust_factor, match_cnt)

func get_info_text() -> String:
	return "For every building adjacent, buildings of that type are 25% cheaper! (stacks)"
