class_name Building
extends Node2D

enum CenterMode { TOP_LEFT, CENTER }

var grid: PackedByteArray
var dimensions: Vector2i
var center_coords: Vector2i
var center_mode: CenterMode

var building_grid: BuildingGrid
var pos_coords: Vector2i

@onready var sprite: Sprite2D = $Sprite2D

@onready var rotation_value: int = 0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func init_sprite() -> void:
	sprite.centered = false
	var center_px = center_coords * BuildingGrid.GRID_SPACE_SIZE
	if center_mode == CenterMode.CENTER:
		center_px += Vector2i(1, 1) * (BuildingGrid.GRID_SPACE_SIZE / 2)
	sprite.offset = -center_px
	sprite.position = center_px

func set_origin_coords(coords: Vector2i) -> void:
	position = BuildingGrid.GRID_SPACE_SIZE * coords
	pos_coords = coords

func rotate_building(dir: ClockDirection) -> void:
	# Update grid
	grid = rotate_grid_around(grid, dimensions, center_coords, center_mode, dir)

	# Rotate sprite
	var cw = dir == CLOCKWISE
	var delta_rot = 1 if cw else -1
	rotation_value += delta_rot
	sprite.rotation = PI / 2 * rotation_value


static func rotate_grid_around(
		grid: PackedByteArray,
		dimensions: Vector2i,
		center: Vector2i,
		center_mode: CenterMode,
		dir: ClockDirection) -> PackedByteArray:
	# Create the new grid
	var new_grid: PackedByteArray = BuildingGrid.make_byte_grid(dimensions)

	# Find the "true center" (we double everything in size since square centers can be
	# in the middle of a square or in a corner)
	var true_center: Vector2i = center * 2
	if center_mode == CenterMode.CENTER:
		true_center += Vector2i(1, 1)

	# Loop through each coordinate and rotate it
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			# If there's already nothing at the grid spot, skip over it
			var coord: Vector2i = Vector2i(x, y)
			var value: int = BuildingGrid.grid_at(grid, dimensions, coord)
			if value == 0:
				continue

			# Double the scale of the grid and find the offset from the center
			var true_coord: Vector2i = coord * 2 + Vector2i(1, 1)
			var delta_center: Vector2 = true_coord - true_center

			# Rotate the offset in the direction given by dir
			var true_new_coord: Vector2i = true_center + (
				Vector2i(-delta_center.y, delta_center.x)
					if dir == CLOCKWISE else
				Vector2i(delta_center.y, -delta_center.x)
			)

			# Convert the new offset to a grid square and set it
			var new_coord: Vector2i = true_new_coord / 2
			BuildingGrid.set_grid_at(new_grid, dimensions, new_coord, value)

	return new_grid

