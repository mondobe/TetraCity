class_name Building
extends Node2D
## Controls buildings that have been placed on the grid.
## For rotation details, see: https://tetris.wiki/Super_Rotation_System

## Options for a building's center of rotation.
## For example, T-blocks have the center of rotation in the middle of a block,
## while I-blocks have it in the corner of two blocks.
enum CenterMode { TOP_LEFT, CENTER }

## Options for a building's kick mode (basically, whether it looks more like
## a T-block or an I-block)
enum KickMode { NORMAL, LONG }

## The blueprint on which this building was based.
var blueprint: BuildingBlueprint

## The blueprint variation this building uses (containing alternate sprite information).
var variation: BuildingVariation

## The building's grid of pixels. The size is equal to the bounding box size,
## and the grid is filled with a 1 (if there is a pixel) or 0 (if there isn't).
var grid: Grid

## The grid in which this building is to be placed.
var building_grid: BuildingGrid

## This building's current position in the building grid.
var pos_coords: Vector2i

## The node that defines what bonus is applied by this building.
var bonus: Node

## Times a building has been weight-boosted by an adjacent church
var times_church_boosted: int

## The Sprite2D component that displays the building's texture.
@onready var sprite: Sprite2D = $Sprite2D

## The guide arrows that show players the ropes.
@onready var guide: Sprite2D = $Guide

## How rotated this building is (i.e. the number of clockwise rotations from
## the starting point)
@onready var rotation_value: int = 0

## Initialize this building from the specified blueprint.
func init_from_blueprint_variation(variation: BuildingVariation) -> void:
	self.blueprint = variation.blueprint
	self.variation = variation
	self.grid = BuildingGrid.byte_grid_from_string(variation.squares)

	sprite = $Sprite2D
	sprite.texture = variation.sprite
	_init_sprite()

	bonus = $Bonus
	bonus.set_script(blueprint.bonus)

## Move the Sprite2D child to the correct position and offset for rotation
func _init_sprite() -> void:
	sprite.centered = false
	var center_px = variation.center_coords * BuildingGrid.GRID_SPACE_SIZE
	if variation.center_mode == CenterMode.CENTER:
		center_px += Vector2i(1, 1) * (BuildingGrid.GRID_SPACE_SIZE / 2)
	sprite.offset = -center_px
	sprite.position = center_px

	guide = $Guide
	guide.position = center_px + Vector2i.UP * 50

func done_placing() -> void:
	guide.hide()

## Set the building's position in the building grid and move its transform
func set_origin_coords(coords: Vector2i) -> void:
	position = BuildingGrid.GRID_SPACE_SIZE * coords
	pos_coords = coords

## Rotate the building in the specified direction
func rotate_building(dir: ClockDirection) -> void:
	# Update grid
	grid = rotate_grid_around(grid, variation.center_coords, variation.center_mode, dir)

	# Rotate sprite
	var cw = dir == CLOCKWISE
	var delta_rot = 1 if cw else -1
	rotation_value += delta_rot
	rotation_value %= 4
	sprite.rotation = PI / 2 * rotation_value

## Calculate the position of each pixel in a rotated building grid using an
## offset rotation matrix.
static func rotate_grid_around(
		grid: Grid,
		center: Vector2i,
		center_mode: CenterMode,
		dir: ClockDirection) -> Grid:
	# Create the new grid
	var new_grid: Grid = Grid.new(grid.type, grid.dimensions)

	# Find the "true center" (we double everything in size since square centers can be
	# in the middle of a square or in a corner)
	var true_center: Vector2i = center * 2
	if center_mode == CenterMode.CENTER:
		true_center += Vector2i(1, 1)

	# Loop through each coordinate and rotate it
	for x in range(grid.dimensions.x):
		for y in range(grid.dimensions.y):
			# If there's already nothing at the grid spot, skip over it
			var coord: Vector2i = Vector2i(x, y)
			var value: int = grid.at(coord)
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
			new_grid.set_at(new_coord, value)

	return new_grid

## This building's index in the building grid
func get_index_in_grid() -> int:
	return building_grid.buildings.find(self)

## The buildings adjacent to this one. Returns an array of nodes
func get_adjacent_buildings() -> Array:
	var index = get_index_in_grid()
	var indices = building_grid.get_adjacent_building_indices(index)
	return indices.map(func(i): return building_grid.buildings[i])

func get_center_position() -> Vector2:
	return global_position + Vector2(variation.center_coords * building_grid.GRID_SPACE_SIZE)
