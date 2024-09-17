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

@export var _moving_camera: MovingCamera

## Debug variable for what buildings can be placed when you press SPACE.
@export var _test_blueprints: Array[BuildingBlueprint]

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_grid()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If SPACE is pressed, add a new random building
	if (Input.is_action_just_pressed("test_create_building")
		and not placing_building
		and _moving_camera.get_camera_mode() == MovingCamera.CameraMode.GROUND):
		var blueprint = _test_blueprints[randi_range(0, len(_test_blueprints) - 1)]
		placing_building = make_building_from_blueprint(blueprint)
		start_placing(placing_building)

	if placing_building:
		placing_process(delta)

## Start placing a new building. Sets the building at the top center of the grid
## and restarts the timer.
func start_placing(new_building: Building) -> void:
	new_building.set_origin_coords(Vector2i(
			grid.dimensions.x / 2 - new_building.grid.dimensions.x / 2, 0))
	add_child(new_building)
	push_timer = MAX_PUSH_TIMER

## Called every frame while placing a building.
func placing_process(delta: float) -> void:
	# Respond to keypresses by rotating left and right
	if Input.is_action_just_pressed("rotate_left"):
		test_rotate_building(placing_building, COUNTERCLOCKWISE)
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	if Input.is_action_just_pressed("rotate_right"):
		test_rotate_building(placing_building, CLOCKWISE)
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	# Hard Drop
	if Input.is_action_just_pressed("move_up"):
		while test_move_building(placing_building, Vector2i(0, 1)):
			continue
		push_timer = MAX_PUSH_TIMER

	# Soft Drop
	if Input.is_action_just_pressed("move_down"):
		test_move_building(placing_building, Vector2i(0, 1))
		push_timer = MAX_PUSH_TIMER

	# Move left
	if Input.is_action_just_pressed("move_left"):
		test_move_building(placing_building, Vector2i(-1, 0))

	# Move right
	if Input.is_action_just_pressed("move_right"):
		test_move_building(placing_building, Vector2i(1, 0))

	# If the push timer is below zero, stop moving the building
	push_timer -= delta
	if push_timer < 0:
		if not test_move_building(placing_building, Vector2i(0, 1)):
			done_placing()
		push_timer = MAX_PUSH_TIMER

## Add the current building to the grid and rebuild its collision.
func done_placing() -> void:
	buildings.append(placing_building)
	build_grid()
	placing_building = null

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
				if building.blueprint.kick_mode == Building.KickMode.NORMAL else
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
func make_building_from_blueprint(blueprint: BuildingBlueprint) -> Building:
	var new_building: Building = building.instantiate()
	new_building.init_from_blueprint(blueprint)
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
