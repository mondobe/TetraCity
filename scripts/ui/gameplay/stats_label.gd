class_name StatsLabel
extends Label
## Controls the label that shows coins, day, etc.

## The node that holds the world's stats.
@export var world_stats: WorldStats

@onready var bump_timer = 0

@onready var start_y = position.y

func _process(delta: float) -> void:
	position.y = start_y - maxf(bump_timer, 0) * 40
	bump_timer -= delta

func bump() -> void:
	if world_stats.day == 2:
		bump_timer = 0.2
	else:
		bump_timer = 0.08

## Update the label to match the world.
func update() -> void:
	text = "Day %d - %d coins - %d fuel" % [world_stats.day, world_stats.coins, world_stats.fuel]
