class_name BuildingGrid
extends Node2D

const MAX_PUSH_TIMER: float = 1.0
const GRID_SPACE_SIZE: int = 20
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

# Test scene variables
@export var _test_blueprints: Array[BuildingBlueprint]

@export var _initial_dimensions: Vector2i

@export var building: PackedScene

var placing_building: Building
var push_timer: float

@onready var grid: Grid
@onready var buildings: Array[Building]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_grid()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("test_create_building") and not placing_building):
		if placing_building:
			done_placing()
		var blueprint = _test_blueprints[randi_range(0, len(_test_blueprints) - 1)]
		placing_building = make_building_from_blueprint(blueprint)
		start_placing(placing_building)

	if placing_building:
		placing_process(delta)


func start_placing(new_building: Building) -> void:
	new_building.set_origin_coords(Vector2i(
			grid.dimensions.x / 2 - new_building.grid.dimensions.x / 2, 0))
	add_child(new_building)
	push_timer = MAX_PUSH_TIMER

func placing_process(delta: float) -> void:
	if Input.is_action_just_pressed("rotate_left"):
		test_rotate_building(placing_building, COUNTERCLOCKWISE)
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	if Input.is_action_just_pressed("rotate_right"):
		test_rotate_building(placing_building, CLOCKWISE)
		if push_timer < MAX_PUSH_TIMER / 2:
			push_timer = MAX_PUSH_TIMER / 2

	if Input.is_action_just_pressed("move_up"):
		while test_move_building(placing_building, Vector2i(0, 1)):
			continue
		push_timer = MAX_PUSH_TIMER

	if Input.is_action_just_pressed("move_down"):
		test_move_building(placing_building, Vector2i(0, 1))
		push_timer = MAX_PUSH_TIMER

	if Input.is_action_just_pressed("move_left"):
		test_move_building(placing_building, Vector2i(-1, 0))

	if Input.is_action_just_pressed("move_right"):
		test_move_building(placing_building, Vector2i(1, 0))

	push_timer -= delta
	if push_timer < 0:
		if not test_move_building(placing_building, Vector2i(0, 1)):
			done_placing()
		push_timer = MAX_PUSH_TIMER

func done_placing() -> void:
	buildings.append(placing_building)
	build_grid()
	placing_building = null

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


func test_move_building(building: Building, amount: Vector2i) -> bool:
	var new_coords: Vector2i = building.pos_coords + amount
	var test: bool = building_allowed_at_coords(building, new_coords)
	if test:
		building.set_origin_coords(new_coords)
	return test

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

static func other_direction(direction: ClockDirection) -> ClockDirection:
	return CLOCKWISE if direction == COUNTERCLOCKWISE else COUNTERCLOCKWISE

func building_allowed_at_coords(building: Building, coords: Vector2i) -> bool:
	for x in range(building.grid.dimensions.x):
		for y in range(building.grid.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			if building.grid.at(xy) == 0:
				continue
			var grid_xy: Vector2i = xy + coords
			if (grid_xy.x < 0 or grid_xy.x >= grid.dimensions.x) \
					or (grid_xy.y < 0 or grid_xy.y >= grid.dimensions.y):
				return false
			if building_index_at(grid_xy) != 0:
				return false
	return true

func make_building_from_blueprint(blueprint: BuildingBlueprint) -> Building:
	var new_building: Building = building.instantiate()
	new_building.init_from_blueprint(blueprint)
	return new_building

func building_index_at(coords: Vector2i) -> int:
	return grid.at(coords)

static func grid_dimensions_from_string(string: String) -> Vector2i:
	var width: int = string.find("\n")
	var height: int = (string.length() - string.count("\n")) / width
	return Vector2i(width, height)

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
