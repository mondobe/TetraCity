class_name WorldStats
extends Node
## Holds/updates the main gameplay statistics.

## The label that displays the statistics.
@export var top_label: StatsLabel

## The node that handles building bonuses.
@export var building_bonuses: BuildingBonuses

## The building grid.
@export var building_grid: BuildingGrid

## The node in charge of spawning balloons.
@export var balloon_spawn_ai: BalloonSpawnAI

## The amount of coins the player has.
var coins

## The amount of fuel the player has.
var fuel

## The current day (starting from 1).
var day

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_values()
	top_label.update()

# Called every frame
func _process(delta: float) -> void:
	# Placeholder for now! Hopefully we have an "end day" button soon
	if Input.is_action_just_pressed("test_end_day"):
		end_day()
		top_label.update()

## Initialize values at the start of the game
func init_values() -> void:
	coins = 5
	fuel = 60
	day = 1

## Update the values for each day
func end_day() -> void:
	if building_grid.placing_building:
		return
	fuel -= 1
	day += 1
	building_bonuses.apply_bonuses()
	balloon_spawn_ai.on_new_day()


