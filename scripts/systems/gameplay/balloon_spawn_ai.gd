class_name BalloonSpawnAI
extends Node
## Controls when NPC balloons spawn each day.

## The sky view controls.
@export var _sky_view_controls: SkyViewControls

@export var _world_stats: WorldStats

@export var _blueprints: Array[BuildingBlueprint]

@onready var buildings_in_world: Dictionary = Dictionary()

@onready var balloons: Array[Balloon] = []

## Random Sampling
@export_category("Inverse Weighting")

## Weight pools
@export var apartment_weight: float = 400

@export var park_weight: float = 150

@export var cafe_weight: float = 133

@export var school_weight: float = 133

@export var church_weight: float = 133

@export var solar_weight: float = 51

## Weight factors (how much a weight decreases upon being chosen)

@export var apartment_factor: float = 10

@export var park_factor: float = 26

@export var cafe_factor: float = 30

@export var school_factor: float = 30

@export var church_factor: float = 30

@export var solar_factor: float = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn("city_hall", 0, -1)
	spawn("apartment", 5, -1)

## Called each day to spawn random NPCs.
func on_new_day() -> void:
	var day = _world_stats.day
	
	if day == 1:
		return
		
	if day == 50:
		spawn("nuclear_reactor", 700, -1)
	
	for balloon in balloons:
		balloon.lifetime -= 1
		if balloon.lifetime <= 0:
			balloon.queue_free()
			buildings_in_world[balloon.blueprint] -= 1
			
	balloons = balloons.filter(
		func(b: Balloon) -> bool:
			return b.lifetime > 0
	)
		
	var spawn_count = 0
	var roll: float = randf()
	
	if roll < .07:
		spawn_count = 1
	elif roll < .67:
		spawn_count = 2
	elif roll < .95:
		spawn_count = 3
	else:
		spawn_count = 4
		
	if OS.is_debug_build():
		print("Day: ", _world_stats.day)
		print("Spawn #: ", spawn_count)
	
	while spawn_count >= 1:
		var choice = choose_building()
		
		# TODO:REMOVE ONCE CHURCHS ARE ADDED
		while choice == 4:
			choice = choose_building()
			
		# TODO:REMOVE ONCE CHURCHS ARE ADDED
		if choice == 5:
			choice -= 1
			
		choice += 2
		var blueprint = _blueprints[choice]
		choice -= 2
		
		# TODO:REMOVE ONCE CHURCHS ARE ADDED
		if choice == 4:
			choice += 1
			
		var var_name: String = blueprint.variations.pick_random()
		var price = get_price(day, choice)
		spawn(var_name, price, choice)
		spawn_count -= 1


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
		spawn(var_name, price, 0)

## Spawn the building with the given variation in a random position with the
## given price.
func spawn(name: String, price: int, choice: int) -> void:
	var v: BuildingVariation = load("res://buildings/variations/%s.tres" % name)
	spawn_variation(v, price, choice)

## Spawn the building with the given filename in a random position with the
## given price.
func spawn_variation(variation: BuildingVariation, price: int, choice: int) -> void:
	var balloon = _sky_view_controls.spawn_balloon(price, variation, choice)
	balloons.append(balloon)
	buildings_in_world[variation.blueprint] = (
		buildings_in_world.get(variation.blueprint, 0) + 1)

func remove_balloon(balloon: Balloon) -> void:
	balloon.queue_free()
	balloons.erase(balloon)
	
func choose_building():
	var weights = [apartment_weight, park_weight, cafe_weight, school_weight, church_weight, solar_weight]
	
	var normalization_constant = 0
	for i in range(weights.size()):
		if weights[i] <= 0:
			normalization_constant += abs(weights[i]) + 1
			weights[i] = 1
	
	for i in range(weights.size()):
		if weights[i] != 1:
			weights[i] += normalization_constant
	
	if OS.is_debug_build():
		print("Weights: ", weights)

	var factors = [apartment_factor, park_factor, cafe_factor, school_factor, church_factor, solar_factor]
	
	var sum = apartment_weight + park_weight + cafe_weight + school_weight + church_weight + solar_weight
	## Probabilites of buildings
	var apartment_prob: float = weights[0] / sum
	var park_prob: float = weights[1] / sum
	var cafe_prob: float = weights[2] / sum
	var school_prob: float = weights[3] / sum
	var church_prob: float = weights[4] / sum
	var solar_prob: float = weights[5] / sum
	
	var probs = [apartment_prob, park_prob, cafe_prob, school_prob, church_prob, solar_prob]
	
	if OS.is_debug_build():
		print("Probs: ", probs)
		
	## Probability Thresholds
	var apartment_threshold: float = apartment_prob
	var park_threshold: float = apartment_threshold + park_prob
	var cafe_threshold: float = park_threshold + cafe_prob
	var school_threshold: float = cafe_threshold + school_prob
	var church_threshold: float = school_threshold + church_prob
	#var solar_threshold: float = church_threshold + solar_prob

	var rng = RandomNumberGenerator.new()
	var roll: float = rng.randf()
	var result: int = 0
	
	if roll < apartment_threshold:
		result = 0
	elif roll < park_threshold:
		result = 1
	elif roll < cafe_threshold:
		result = 2
	elif roll < school_threshold:
		result = 3
	elif roll < church_threshold:
		result = 4
	else:
		result = 5
	
	return result

func update_weights(choice: int) -> void:
	if choice == -1:
		return
	
	if OS.is_debug_build():
		print("Bought building choice: ", choice)
	
	var weights = [apartment_weight, park_weight, cafe_weight, school_weight, church_weight, solar_weight]
	var factors = [apartment_factor, park_factor, cafe_factor, school_factor, church_factor, solar_factor]
	
	var sum = apartment_weight + park_weight + cafe_weight + school_weight + church_weight + solar_weight
	
	## Probabilites of buildings
	var apartment_prob: float = weights[0] / sum
	var park_prob: float = weights[1] / sum
	var cafe_prob: float = weights[2] / sum
	var school_prob: float = weights[3] / sum
	var church_prob: float = weights[4] / sum
	var solar_prob: float = weights[5] / sum
	
	var probs = [apartment_prob, park_prob, cafe_prob, school_prob, church_prob, solar_prob]
	
	for i in range(weights.size()):
		if i == choice:
			weights[i] -= factors[choice]
		else:
			# weights[i] += factors[result] * probs[i]
			weights[i] += factors[i] * probs[i]
	
	
	apartment_weight = weights[0]
	park_weight = weights[1]
	cafe_weight = weights[2]
	school_weight = weights[3]
	church_weight = weights[4]
	solar_weight = weights[5]

	sum = apartment_weight + park_weight + cafe_weight + school_weight + church_weight + solar_weight
	
	apartment_prob = weights[0] / sum
	park_prob = weights[1] / sum
	cafe_prob = weights[2] / sum
	school_prob = weights[3] / sum
	church_prob = weights[4] / sum
	solar_prob = weights[5] / sum
	
	probs = [apartment_prob, park_prob, cafe_prob, school_prob, church_prob, solar_prob]
	
	if OS.is_debug_build():
		print("Weights: ", weights)
		print("Probs: ", probs)

func get_price(day: int, choice: int):
	var price: int
	match choice:
		0:
			price = floor(5 * exp(0.07 * day))
		1:
			price = floor(7 * exp(0.07 * day))
		2:
			price = floor(8 * exp(0.07 * day))
		3:
			price = floor(9 * exp(0.07 * day))
		4:
			##TODO: ADD CHUCH
			price = 0
		5:
			price = floor(11 * exp(0.07 * day))
	return price
