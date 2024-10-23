class_name BalloonSpawnAI
extends Node
## Controls when NPC balloons spawn each day.

## The sky view controls.
@export var _sky_view_controls: SkyViewControls

@export var _world_stats: WorldStats

@export var _blueprints: Array[BuildingBlueprint]

@onready var buildings_in_world: Dictionary = Dictionary()

@onready var balloons: Array[Balloon] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn("city_hall", 0)
	spawn("apartment", 5)

## Called each day to spawn random NPCs.
func on_new_day() -> void:
	for balloon in balloons:
		balloon.lifetime -= 1
		if balloon.lifetime <= 0:
			balloon.queue_free()
			buildings_in_world[balloon.blueprint] -= 1

	balloons = balloons.filter(
		func(b: Balloon) -> bool:
			return b.lifetime > 0
	)

	for blueprint: BuildingBlueprint in _blueprints:
		test_blueprint(blueprint)

func test_blueprint(blueprint: BuildingBlueprint) -> void:
	var day = _world_stats.day
	if day < blueprint.first_spawning_day:
		return

	var num_in_world = mini(buildings_in_world.get(blueprint, 0), blueprint.probabilities.size() - 1)
	var prob = blueprint.probabilities[num_in_world]
	if randf() < prob:
		var var_name: String = blueprint.variations.pick_random()
		var price_increase = blueprint.daily_increase * (day - blueprint.first_spawning_day)
		var price: int = roundi(blueprint.starting_price + price_increase)
		spawn(var_name, price)

## Spawn the building with the given variation in a random position with the
## given price.
func spawn(name: String, price: int) -> void:
	var v: BuildingVariation = load("res://buildings/variations/%s.tres" % name)
	spawn_variation(v, price)

## Spawn the building with the given filename in a random position with the
## given price.
func spawn_variation(variation: BuildingVariation, price: int) -> void:
	var balloon = _sky_view_controls.spawn_balloon(price, variation)
	balloons.append(balloon)
	buildings_in_world[variation.blueprint] = (
		buildings_in_world.get(variation.blueprint, 0) + 1)

func remove_balloon(balloon: Balloon) -> void:
	balloon.queue_free()
	balloons.erase(balloon)
