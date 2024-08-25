class_name BuildingGrid
extends Node2D

const GRID_SPACE_SIZE: int = 20

# Test scene variables
var test_building: Building
@export var test_blueprints: Array[BuildingBlueprint]

@export var _initial_dimensions: Vector2i

@export var building: PackedScene

var _placing_index: int

@onready var grid: PackedInt32Array = make_grid(_initial_dimensions)
@onready var buildings: Array[Building]

@onready var dimensions: Vector2i = _initial_dimensions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("test_create_building")):
		var blueprint = test_blueprints[randi_range(0, len(test_blueprints) - 1)]
		test_building = make_building_from_blueprint(blueprint)

	if test_building:
		if (Input.is_action_just_pressed("rotate_left")):
			test_building.rotate_building(COUNTERCLOCKWISE)
			print(byte_grid_to_string(test_building.grid, test_building.dimensions))

		if (Input.is_action_just_pressed("rotate_right")):
			test_building.rotate_building(CLOCKWISE)
			print(byte_grid_to_string(test_building.grid, test_building.dimensions))

		if (Input.is_action_just_pressed("move_up")):
			test_building.set_origin_coords(test_building.pos_coords + Vector2i(0, -1))

		if (Input.is_action_just_pressed("move_down")):
			test_building.set_origin_coords(test_building.pos_coords + Vector2i(0, 1))

		if (Input.is_action_just_pressed("move_left")):
			test_building.set_origin_coords(test_building.pos_coords + Vector2i(-1, 0))

		if (Input.is_action_just_pressed("move_right")):
			test_building.set_origin_coords(test_building.pos_coords + Vector2i(1, 0))


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
