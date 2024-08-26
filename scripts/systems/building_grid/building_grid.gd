class_name BuildingGrid
extends Node2D

const GRID_SPACE_SIZE: int = 20

# Test scene variables
@export var _test_blueprints: Array[BuildingBlueprint]

@export var _initial_dimensions: Vector2i

@export var building: PackedScene

var placing_building: Building

@onready var grid: PackedInt32Array = make_grid(_initial_dimensions)
@onready var buildings: Array[Building]

@onready var dimensions: Vector2i = _initial_dimensions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("test_create_building")):
		if placing_building:
			buildings.append(placing_building)
			build_grid()
		var blueprint = _test_blueprints[randi_range(0, len(_test_blueprints) - 1)]
		placing_building = make_building_from_blueprint(blueprint)

	if placing_building:
		if (Input.is_action_just_pressed("rotate_left")):
			placing_building.rotate_building(COUNTERCLOCKWISE)

		if (Input.is_action_just_pressed("rotate_right")):
			placing_building.rotate_building(CLOCKWISE)

		if (Input.is_action_just_pressed("move_up")):
			test_move_building(placing_building, Vector2i(0, -1))

		if (Input.is_action_just_pressed("move_down")):
			test_move_building(placing_building, Vector2i(0, 1))

		if (Input.is_action_just_pressed("move_left")):
			test_move_building(placing_building, Vector2i(-1, 0))

		if (Input.is_action_just_pressed("move_right")):
			test_move_building(placing_building, Vector2i(1, 0))


func build_grid() -> void:
	grid = make_grid(_initial_dimensions)
	for i in range(buildings.size()):
		var building: Building = buildings[i]
		for x in range(building.dimensions.x):
			for y in range(building.dimensions.y):
				var xy = Vector2i(x, y)
				if building.grid_at(xy) != 0:
					var grid_xy: Vector2i = xy + building.pos_coords
					set_grid_at(grid, dimensions, grid_xy, i + 1)


func test_move_building(building: Building, amount: Vector2i) -> bool:
	var new_coords: Vector2i = building.pos_coords + amount
	var test: bool = building_allowed_at_coords(building, new_coords)
	if test:
		building.set_origin_coords(new_coords)
	return test

func building_allowed_at_coords(building: Building, coords: Vector2i) -> bool:
	for x in range(building.dimensions.x):
		for y in range(building.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			if building.grid_at(xy) == 0:
				continue
			var grid_xy: Vector2i = xy + coords
			if (grid_xy.x < 0 or grid_xy.x >= dimensions.x) \
					or (grid_xy.y < 0 or grid_xy.y >= dimensions.y):
				return false
			if building_index_at(grid_xy) != 0:
				return false
	return true

func make_building_from_blueprint(blueprint: BuildingBlueprint) -> Building:
	var new_building: Building = building.instantiate()
	new_building.init_from_blueprint(blueprint)
	add_child(new_building)
	return new_building

static func make_grid(initial_dimensions: Vector2i) -> PackedInt32Array:
	var grid = PackedInt32Array()
	grid.resize(initial_dimensions.x * initial_dimensions.y)
	grid.fill(0)
	return grid

static func make_byte_grid(initial_dimensions: Vector2i) -> PackedByteArray:
	var grid = PackedByteArray()
	grid.resize(initial_dimensions.x * initial_dimensions.y)
	grid.fill(0)
	return grid

static func grid_at(grid, dimensions: Vector2i, coords: Vector2i) -> int:
	return grid[coords.y * dimensions.x + coords.x]

static func set_grid_at(grid, dimensions: Vector2i, coords: Vector2i, value) -> void:
	grid[coords.y * dimensions.x + coords.x] = value

func building_index_at(coords: Vector2i) -> int:
	return grid_at(grid, dimensions, coords)

static func grid_dimensions_from_string(string: String) -> Vector2i:
	var width: int = string.find("\n")
	var height: int = (string.length() - string.count("\n")) / width
	return Vector2i(width, height)

static func byte_grid_from_string(string: String) -> PackedByteArray:
	# Takes up a lot of extra memory, could be optimized
	var just_chars = string.replace("\n", "")

	# Get the dimensions of the string and create a byte array
	var dimensions = grid_dimensions_from_string(string)
	var grid: PackedByteArray = make_byte_grid(dimensions)

	# Fill the byte array with the string contents
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			var char: String = just_chars[y * dimensions.x + x]
			var value: int = 1 if char == "O" else 0
			var coord: Vector2i = Vector2i(x, y)
			set_grid_at(grid, dimensions, coord, value)

	return grid

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
