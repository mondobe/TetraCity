class_name BuildingGrid
extends Node2D

const GRID_SPACE_SIZE: int = 20

@export var _initial_dimensions: Vector2i

var _placing_index: int

@onready var grid: PackedInt32Array = make_grid(_initial_dimensions)
@onready var buildings: Array[Building]

@onready var dimensions: Vector2i = _initial_dimensions

@onready var test_building = $Building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var string = \
"....
OOOO
....
....
"
	var test_grid: PackedByteArray = byte_grid_from_string(string)
	var grid_dimensions: Vector2i = grid_dimensions_from_string(string)
	print(byte_grid_to_string(test_grid, grid_dimensions))

	var test_building: Building = $Building
	test_building.grid = test_grid
	test_building.dimensions = grid_dimensions
	test_building.center_coords = Vector2i(2, 2)
	test_building.center_mode = Building.CenterMode.TOP_LEFT
	test_building.building_grid = self
	test_building.set_origin_coords(Vector2i(0, 0))
	test_building.init_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("rotate_left")):
		test_building.rotate_building(COUNTERCLOCKWISE)
		print(byte_grid_to_string(test_building.grid, test_building.dimensions))

	if (Input.is_action_just_pressed("rotate_right")):
		test_building.rotate_building(CLOCKWISE)
		print(byte_grid_to_string(test_building.grid, test_building.dimensions))

	if (Input.is_action_just_pressed("ui_up")):
		test_building.set_origin_coords(test_building.pos_coords + Vector2i(0, -1))

	if (Input.is_action_just_pressed("ui_down")):
		test_building.set_origin_coords(test_building.pos_coords + Vector2i(0, 1))

	if (Input.is_action_just_pressed("ui_left")):
		test_building.set_origin_coords(test_building.pos_coords + Vector2i(-1, 0))

	if (Input.is_action_just_pressed("ui_right")):
		test_building.set_origin_coords(test_building.pos_coords + Vector2i(1, 0))


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
