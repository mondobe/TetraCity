class_name BuildingBonuses
extends Node
## Handles the bonuses applied daily by buildings.

## The building grid
@export var building_grid: BuildingGrid

## The world stats
@export var world_stats: WorldStats

@export var coin_label: PackedScene

@export var static_ui_layer: CanvasLayer

## Specific blueprints

## Specific blueprints

var church: BuildingBlueprint

func _ready():
	church = load("res://buildings/church.tres")
	
## For each building in the grid, applies the building's daily bonus.
func apply_bonuses() -> void:
	var current_weights = world_stats.balloon_spawn_ai.building_weights.choices
	var building_weights_deltas = world_stats.balloon_spawn_ai.building_weights.choices.duplicate()
	for key in building_weights_deltas:
		building_weights_deltas[key] = 0
	
	for building: Building in building_grid.buildings:
		if building.blueprint == church:
			building.bonus.set_church_parameters(world_stats.churches, world_stats.balloon_spawn_ai.building_weights.choices)
		
		var bonus = building.bonus.get_bonus()
		
		if bonus.spawn_weights:
			world_stats.balloon_spawn_ai.spawn_weights = bonus.spawn_weights
			
		if bonus.building_weights:
			var new_weights = bonus.building_weights.choices
			
			for key in new_weights:
				if new_weights[key] != current_weights[key]:
					building_weights_deltas[key] += new_weights[key] - current_weights[key]
			
		world_stats.coins += bonus.coins
		world_stats.fuel += bonus.fuel
		
		if bonus.coins > 0:
			var label: Label = coin_label.instantiate()
			label.text = "+%d" % bonus.coins
			label.global_position = (static_ui_layer.transform.affine_inverse()
				* building.get_center_position()) + Vector2.UP * 20
			static_ui_layer.add_child(label)
			
	for key in current_weights:
		current_weights[key] += building_weights_deltas[key]
	
	var new_current_weights = WeightedRandom.new()
	new_current_weights.choices = current_weights
	world_stats.balloon_spawn_ai.building_weights = new_current_weights
