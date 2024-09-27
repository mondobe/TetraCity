class_name BalloonSpawnAI
extends Node
## Controls when NPC balloons spawn each day.

## The sky view controls.
@export var _sky_view_controls: SkyViewControls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn("city_hall", 0)
	spawn("apartment", 5)

## Called each day to spawn random NPCs.
func on_new_day() -> void:
	pass

## Spawn the building with the given filename in a random position with the
## given price.
func spawn(name: String, price: int) -> void:
	var v = load("res://buildings/variations/%s.tres" % name)
	_sky_view_controls.spawn_balloon(price, v)
