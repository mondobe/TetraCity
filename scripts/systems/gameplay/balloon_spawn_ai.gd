class_name BalloonSpawnAI
extends Node
## Controls when NPC balloons spawn each day.

## The sky view controls.
@export var _sky_view_controls: SkyViewControls

@export var _world_stats: WorldStats

@export var _building_grid: BuildingGrid

@export var _blueprints: Array[BuildingBlueprint]

@onready var buildings_in_world: Dictionary = Dictionary()

@onready var balloons: Array[Balloon] = []

## Random Sampling
@export_category("Inverse Weighting")

@export var building_weights: WeightedRandom

@export var building_weight_factors: Dictionary

@export var spawn_weights: WeightedRandom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn("city_hall", 0)
	spawn("apartment", 3)

## Called each day to spawn random NPCs.
func on_new_day() -> void:
	var day = _world_stats.day

	for balloon in balloons:
		balloon.lifetime -= 1
		if balloon.lifetime <= 0:
			remove_balloon(balloon, false)
			buildings_in_world[balloon.blueprint] -= 1

	balloons = balloons.filter(
		func(b: Balloon) -> bool:
			return b.lifetime > 0
	)

	if day == 1:
		return

	if day == 50:
		spawn("nuclear_reactor", 1000)
	var spawn_count: int = adjusted_spawn_weights().get_random()
	for i in range(spawn_count):
		var choice = choose_building()
		var var_name: String = choice.variations.pick_random()
		var price = get_price(day, choice)
		spawn(var_name, price)
		spawn_count -= 1

func adjusted_building_weights(weights: WeightedRandom) -> WeightedRandom:
	var new_weights: WeightedRandom = weights.duplicate()
	for building: Building in _building_grid.buildings:
		if building.bonus is Church:
			var church_bonus: BuildingBonus = building.bonus.get_bonus()
			var weight_adjustment: Dictionary = church_bonus.building_weights
			for b_name: String in weight_adjustment.keys():
				if weights.choices.has(b_name):
					new_weights.choices[b_name] = (
						new_weights.choices[b_name] * weight_adjustment[b_name])
	return new_weights

func adjusted_spawn_weights() -> WeightedRandom:
	var church_count: int = _building_grid.buildings.reduce(
		func(accum: int, b: Building) -> int:
			if b.bonus is Church:
				return accum + 1
			return accum
	, 0)
	return Church.produce_spawn_weights(church_count)

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

func remove_balloon(balloon: Balloon, immediate: bool) -> void:
	if immediate:
		balloon.queue_free()
	else:
		balloon.float_away()
	balloons.erase(balloon)

func choose_building() -> BuildingBlueprint:
	var weights: WeightedRandom = adjusted_building_weights(building_weights)
	var building = weights.get_random()

	var blueprint: BuildingBlueprint = building_blueprint_from_name(building)
	if blueprint.first_spawning_day > _world_stats.day:
		return choose_building()
	if (blueprint.name == "solar_farm"
		and buildings_in_world.get(blueprint, 0) >= 2):
		return choose_building()
	return blueprint

func building_blueprint_from_name(name: String) -> BuildingBlueprint:
	return load("res://buildings/%s.tres" % name)

func update_weights(choice: String) -> void:
	if building_weights.choices.has(choice):
		building_weights.choices[choice] *= building_weight_factors[choice]

func get_price(day: int, blueprint: BuildingBlueprint) -> float:
	return blueprint.starting_price * pow(1 + blueprint.daily_increase / 100, day - blueprint.first_spawning_day) + (day - blueprint.first_spawning_day) * blueprint.day_multiplier
