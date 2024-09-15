class_name StatsLabel
extends Label
## Controls the label that shows coins, day, etc.

## The node that holds the world's stats.
@export var world_stats: WorldStats

## Update the label to match the world.
func update() -> void:
	text = "Day %d - %d coins" % [world_stats.day, world_stats.coins]
