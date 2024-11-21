class_name BuildingBonuses
extends Node
## Handles the bonuses applied daily by buildings.

## The building grid
@export var building_grid: BuildingGrid

## The world stats
@export var world_stats: WorldStats

@export var coin_label: PackedScene

@export var static_ui_layer: CanvasLayer

## For each building in the grid, applies the building's daily bonus.
func apply_bonuses() -> void:
	var max: int = 0
	for building: Building in building_grid.buildings:
		var bonus: BuildingBonus = building.bonus.get_bonus()

		world_stats.coins += bonus.coins
		world_stats.fuel += bonus.fuel
		max += bonus.coins
		SavedStats.incrementCoinsEarned(bonus.coins)
		if bonus.coins > 0:
			var label: Label = coin_label.instantiate()
			label.text = "+%d" % bonus.coins
			label.global_position = (static_ui_layer.transform.affine_inverse()
				* building.get_center_position()) + Vector2.UP * 20
			static_ui_layer.add_child(label)
	SavedStats.setMaxCPD(max)
