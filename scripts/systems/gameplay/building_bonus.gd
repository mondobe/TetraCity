extends Resource
class_name BuildingBonus
## Represents a bonus that can be applied daily by a building.
## Initialized via the builder pattern.

## The amount of coins to add to the player's total
var coins: int

## The amount of fuel to add to the player's total
var fuel: int

## The amount by which to adjust the building weight table
var building_weights: Dictionary

## The amount to reweight
## Create a new bonus with the default values.
func _init() -> void:
	self.coins = 0
	self.fuel = 0

## Sets the amount of coins to this value.
func with_coins(coins: int) -> BuildingBonus:
	self.coins = coins
	return self

## Sets the amount of fuel to this value.
func with_fuel(fuel: int) -> BuildingBonus:
	self.fuel = fuel
	return self

func with_buildings_reweighting(weights: Dictionary) -> BuildingBonus:
	self.building_weights = weights
	return self
