class_name Grid
extends Resource
## Represents a 2D grid or matrix that stores integer values.
## There's no normal method for this in Godot, so this class should be used for all grids.

## The type of integers that can be stored in a packed array.
enum GridType { BYTE, INT32, INT64 }

## The array that holds the actual values of the grid.
## Can be a PackedByteArray, a PackedInt32Array, or a PackedInt64Array.
var array

## The dimensions of the grid.
var dimensions: Vector2i

## The type of the grid.
var type: GridType

## Constructs a grid of the specified type and dimensions, then fills it with 0s.
func _init(type: GridType, dimensions: Vector2i) -> void:
	self.type = type
	self.dimensions = dimensions
	match type:
		GridType.BYTE:
			array = PackedByteArray()
		GridType.INT32:
			array = PackedInt32Array()
		GridType.INT64:
			array = PackedInt64Array()
	make_grid(array, dimensions)

## Do these coordinates address a space in the grid?
func contains(coords: Vector2i) -> bool:
	return coords.x >= 0 and coords.x < dimensions.x and coords.y >= 0 and coords.y < dimensions.y

## Get the value at these coordinates.
func at(coords: Vector2i) -> int:
	return array[coords.y * dimensions.x + coords.x]

## Set the value at these coordinates.
func set_at(coords: Vector2i, value) -> void:
	array[coords.y * dimensions.x + coords.x] = value

## Given an array, resizes it to the specified dimensions and zero-fills it.
static func make_grid(array, dimensions: Vector2i) -> void:
	array.resize(dimensions.x * dimensions.y)
	array.fill(0)
