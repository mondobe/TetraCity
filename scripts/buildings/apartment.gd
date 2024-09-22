class_name Apartment
extends Node

## Return a bonus of exactly one coin
func get_bonus() -> BuildingBonus:
	return BuildingBonus.new().with_coins(1)
