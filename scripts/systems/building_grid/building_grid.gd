class_name BuildingGrid
extends Node2D
## Responsible for storing buildings and placing new ones.
## For rotation details, see: https://tetris.wiki/Super_Rotation_System

## The time it takes for a building to be pushed down due to gravity.
const MAX_PUSH_TIMER: float = 1.0

## The size of a grid space in pixels.
const GRID_SPACE_SIZE: int = 20

## A list of tests for wall kicks. Each row represents one rotation amount.
## Basically, unless you're directly working with rotation, don't worry about this stuff.
const NORMAL_KICK_TRANSLATIONS: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -2), Vector2i(-1, -2),
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, 2), Vector2i(1, 2),
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, -2), Vector2i(1, -2),
	Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, 2), Vector2i(-1, 2),
]
const LONG_KICK_TRANSLATIONS: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), Vector2i(-2, -1), Vector2i(1, 2),
	Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-1, 2), Vector2i(2, -1),
	Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(2, 1), Vector2i(-1, -2),
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), Vector2i(1, -2), Vector2i(-2, 1),
]

## The vectors to loop through when looking for adjacent buildings.
const ADJACENT_VECTORS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
]

const HARD_PARTICLES = preload("res://scenes/effects/particles/hard_drop.tscn")
const SOFT_PARTICLES = preload("res://scenes/effects/particles/soft_drop.tscn")
enum ParticleType {HARD, SOFT}

## The moving camera.
@export var _moving_camera: MovingCamera

## The sky view controls.
@export var _sky_view_controls: SkyViewControls

## The balloon spawn AI
@export var _balloon_spawn_ai: BalloonSpawnAI

## The world stats.
@export var world_stats: WorldStats

## Controls the pixel UI layer.
@export var _hud_container: HudContainer

## Debug variable for what buildings can be placed when you press SPACE.
@export var _test_variations: Array[BuildingVariation]

## The width and height of the grid.
@export var _initial_dimensions: Vector2i

## The building scene that gets instantiated when placing a building.
@export var building: PackedScene

## The building currently being placed.
var placing_building: Building

## The amount of time left until the current building is pushed down due to gravity.
var push_timer: float

## The grid that stores which building occupies which position. Query this grid
## to find out which building is at a certain position (0 = no building)
@onready var grid: Grid

## The buildings currently in the grid.
@onready var buildings: Array[Building]

## The building guide squares
@onready var guide: Sprite2D = $GridGuide

@onready var sfx: GridSfx = $GridSfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_grid()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if placing_building:
		placing_process(delta)

## Create a building based on this variation, and begin placing it.
func make_and_place(variation: BuildingVariation) -> void:
	placing_building = make_building_from_blueprint_variation(variation)
	start_placing(placing_building)

## Start placing a new building. Sets the building at the top center of the grid
## and restarts the timer.
func start_placing(new_building: Building) -> void:
	new_building.set_origin_coords(Vector2i(
			grid.dimensions.x / 2 - new_building.grid.dimensions.x / 2, 0))
	add_child(new_building)
	push_timer = MAX_PUSH_TIMER
	guide.show()
	_moving_camera.start_placing(new_building)
	_hud_container.hide_end_day()

## Called every frame while placing a building.
func placing_process(delta: float) -> void:
	# Respond to keypresses by rotating left and right
	if Input.is_action_just_pressed("rotate_left"):
		if test_rotate_building(placing_building, COUNTERCLOCKWISE):
			sfx.play_building_move()
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	if Input.is_action_just_pressed("rotate_right"):
		if test_rotate_building(placing_building, CLOCKWISE):
			sfx.play_building_move()
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	# Hard Drop
	if Input.is_action_just_pressed("move_up"):
		var num_drops: int = 0
		while test_move_building(placing_building, Vector2i(0, 1)):
			num_drops += 1
			continue
		if num_drops > 0:
			sfx.play_hard_drop()
			_moving_camera.shake(0.2)
		if num_drops > 3:
			spawn_particles(ParticleType.HARD);
			_moving_camera.shake(0.5)

		push_timer = MAX_PUSH_TIMER

	# Soft Drop
	if Input.is_action_just_pressed("move_down"):
		if test_move_building(placing_building, Vector2i(0, 1)):
			sfx.play_building_move()
		push_timer = MAX_PUSH_TIMER

	# Move left
	if Input.is_action_just_pressed("move_left"):
		if test_move_building(placing_building, Vector2i(-1, 0)):
			sfx.play_building_move()

	# Move right
	if Input.is_action_just_pressed("move_right"):
		if test_move_building(placing_building, Vector2i(1, 0)):
			sfx.play_building_move()

	# If the push timer is below zero, stop moving the building
	if world_stats.day == 1:
		push_timer -= delta * 0.6
	else:
		push_timer -= delta
	if push_timer < 0:
		if test_move_building(placing_building, Vector2i(0, 1)):
			sfx.play_gravity()
		else:
			done_placing()
			sfx.play_settle()
		push_timer = MAX_PUSH_TIMER

## Add the current building to the grid and rebuild its collision.
func done_placing() -> void:
	buildings.append(placing_building)
	spawn_particles(ParticleType.SOFT);
	build_grid()
	placing_building.done_placing()
	if placing_building.bonus is CityHall:
		_hud_container.end_day_unlocked = true
	_hud_container.show_end_day()
	placing_building = null
	_sky_view_controls.done_placing()
	guide.hide()

## Clears the grid and rebuilds it, polling every building for its collision pixels.
func build_grid() -> void:
	grid = Grid.new(Grid.GridType.INT32, _initial_dimensions)
	for i in range(buildings.size()):
		var building: Building = buildings[i]
		for x in range(building.grid.dimensions.x):
			for y in range(building.grid.dimensions.y):
				var xy = Vector2i(x, y)
				if building.grid.at(xy) != 0:
					var grid_xy: Vector2i = xy + building.pos_coords
					grid.set_at(grid_xy, i + 1)

## Tries to move a building. If there's something in the way, the building is
## moved back.
func test_move_building(building: Building, amount: Vector2i) -> bool:
	var new_coords: Vector2i = building.pos_coords + amount
	var test: bool = building_allowed_at_coords(building, new_coords)
	if test:
		building.set_origin_coords(new_coords)
	return test

## Tries to rotate a building. If there's something in the way, loop through the
## four translations and try to wall kick. If none of those work, rotate the building
## back.
func test_rotate_building(building: Building, direction: ClockDirection) -> bool:
	building.rotate_building(direction)
	for step in range(5):
		var t_index: int = step + building.rotation_value * 5
		var translation: Vector2i = (
				NORMAL_KICK_TRANSLATIONS[t_index]
				if building.variation.kick_mode == Building.KickMode.NORMAL else
				LONG_KICK_TRANSLATIONS[t_index])
		if direction == COUNTERCLOCKWISE:
			translation = -translation
		var new_coords: Vector2i = building.pos_coords + translation
		if building_allowed_at_coords(building, new_coords):
			building.set_origin_coords(new_coords)
			return true
	building.rotate_building(other_direction(direction))
	return false

## Given a ClockDirection (clockwise or counter-clockwise), returns the other direction.
static func other_direction(direction: ClockDirection) -> ClockDirection:
	return CLOCKWISE if direction == COUNTERCLOCKWISE else COUNTERCLOCKWISE

## Determines whether a building can be placed at a certain coordinate or
## whether another building is blocking the way.
func building_allowed_at_coords(building: Building, coords: Vector2i) -> bool:
	for x in range(building.grid.dimensions.x):
		for y in range(building.grid.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			if building.grid.at(xy) == 0:
				continue
			var grid_xy: Vector2i = xy + coords
			if !grid.contains(grid_xy):
				return false
			if grid.at(grid_xy) != 0:
				return false
	return true

## Instantiates a building and initializes it from the blueprint.
func make_building_from_blueprint_variation(variation: BuildingVariation) -> Building:
	var new_building: Building = building.instantiate()
	new_building.init_from_blueprint_variation(variation)
	new_building.building_grid = self
	return new_building

## Get the indices of the buildings adjacent to the one at the specified index.
func get_adjacent_building_indices(building_index: int) -> Array[int]:
	var indices: Array[int] = []
	for x: int in range(grid.dimensions.x):
		for y: int in range(grid.dimensions.y):
			var coords: Vector2i = Vector2i(x, y)
			if grid.at(coords) - 1 != building_index:
				continue
			for adj in ADJACENT_VECTORS:
				var coords_prime: Vector2i = coords + adj
				if grid.contains(coords_prime):
					var adj_index = grid.at(coords_prime) - 1
					if adj_index != building_index \
							and adj_index not in indices \
							and adj_index >= 0:
						indices.append(adj_index)
	return indices

## Given a grid string, returns the width and height.
static func grid_dimensions_from_string(string: String) -> Vector2i:
	var width: int = string.find("\n")
	var height: int = (string.length() - string.count("\n")) / width
	return Vector2i(width, height)

## Given a string arranged in a square, where '.' represents 0 and 'O' (capital
## O, the letter) represents 1, create a grid from it.
static func byte_grid_from_string(string: String) -> Grid:
	# Takes up a lot of extra memory, could be optimized
	var just_chars = string.replace("\n", "")

	# Get the dimensions of the string and create a byte array
	var dimensions = grid_dimensions_from_string(string)
	var grid: Grid = Grid.new(Grid.GridType.BYTE, dimensions)

	# Fill the byte array with the string contents
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			var char: String = just_chars[y * dimensions.x + x]
			var value: int = 1 if char == "O" else 0
			var coord: Vector2i = Vector2i(x, y)
			grid.set_at(coord, value)

	return grid

## Given a byte grid, return its string representation.
static func byte_grid_to_string(grid: PackedByteArray, dimensions: Vector2i) -> String:
	var string: String = ""

	# Iterate through the grid and add the value representation
	for i in range(len(grid)):
		var value: int = grid[i]

		# Add the value
		string += "O" if value == 1 else "."

		# Loop to a new row if this one is full
		if (i % dimensions.x) == (dimensions.x - 1):
			string += "\n"

	return string

## Given a global position, finds the grid space it's in (used to spawn the info
## box when clicking on a building)
func global_coords_to_grid_space(point: Vector2) -> Vector2i:
	var relative_point: Vector2 = point - global_position
	var spaces: Vector2 = relative_point / GRID_SPACE_SIZE
	return Vector2i(spaces)

## Given a grid space, find its total position
func top_corner_of_space(coords: Vector2i) -> Vector2:
	var offset: Vector2 = Vector2(coords) * GRID_SPACE_SIZE
	var global_point: Vector2 = offset + global_position
	return global_point

func building_gets_sun(building: Building) -> bool:
	# Loop through all squares in the bounding box
	for x: int in range(building.grid.dimensions.x):
		for y: int in range(building.grid.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			# If there is a building square here...
			if building.grid.at(xy) == 1:
				var grid_xy: Vector2i = building.pos_coords + xy
				# If the square gets sun, add fuel
				if test_coord_gets_sun(grid_xy + Vector2i.UP):
					return true
	return false

# Recursively tests if a square on the grid is blocked by another building above it
func test_coord_gets_sun(coord: Vector2i) -> bool:
	# If we reach the top of the grid, nothing has blocked us
	if not grid.contains(coord):
		return true
	# If there's no building here, try the square above
	elif grid.at(coord) == 0:
		return test_coord_gets_sun(coord + Vector2i.UP)
	# There's a building blocking the square
	else:
		return false

# Spawn those particles!
func spawn_particles(variation: ParticleType) -> void:
	for x in range(placing_building.grid.dimensions.x):
		for y in range(placing_building.grid.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			if placing_building.grid.at(xy) == 0:
				continue
			var grid_xy: Vector2i = xy + placing_building.pos_coords
			var particle_node = (HARD_PARTICLES if variation == ParticleType.HARD else SOFT_PARTICLES).instantiate()
			add_sibling(particle_node)
			var particles = particle_node.get_child(0)
			particles.global_position = top_corner_of_space(grid_xy)
			particles.global_position += Vector2(10, 10)
			particles.emitting = true

# Destroy the list of buildings, and play the given effect. Used in natural disasters
func destroy_buildings(to_destroy: Array[Building], effect_scene: PackedScene) -> void:
	buildings = buildings.filter(
		func(building: Building) -> bool:
			return building not in to_destroy
	)

	for building: Building in to_destroy:
		for x: int in range(building.grid.dimensions.x):
			for y: int in range(building.grid.dimensions.y):
				if building.grid.at(Vector2(x, y)) == 1:
					var effect = effect_scene.instantiate()
					add_sibling(effect)

					var coords = Vector2i(x, y) + building.pos_coords
					var top_corner = top_corner_of_space(coords)
					effect.global_position = top_corner

		building.queue_free()
		_balloon_spawn_ai.buildings_in_world[building.blueprint] -= 1;

	build_grid()
