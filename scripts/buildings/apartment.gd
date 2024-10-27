class_name Apartment
extends Node

## Return a bonus of exactly one coin
func get_bonus() -> BuildingBonus:
	return BuildingBonus.new().with_coins(1)

func get_info_text() -> String:
	return "Earns one coin per day."

func get_price(day: int) -> int:
	var price = floor(6 * exp(0.07 * day))
	return price
