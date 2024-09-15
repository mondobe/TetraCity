class_name BuildingBonuses
extends Node
## Handles the bonuses applied daily by buildings.

## The building grid
@export var building_grid: BuildingGrid

## The world stats
@export var world_stats: WorldStats

## For each building in the grid, applies the building's daily bonus.
func apply_bonuses() -> void:
	for building: Building in building_grid.buildings:
		var bonus: BuildingBonus = building.bonus.get_bonus()
		world_stats.coins += bonus.coins
		world_stats.fuel += bonus.fuel
