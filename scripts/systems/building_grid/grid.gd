class_name Grid
extends Resource

enum GridType { BYTE, INT32, INT64 }

var array
var dimensions: Vector2i
var type: GridType

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


func at(coords: Vector2i) -> int:
	return array[coords.y * dimensions.x + coords.x]

func set_at(coords: Vector2i, value) -> void:
	array[coords.y * dimensions.x + coords.x] = value

static func make_grid(array, dimensions: Vector2i) -> void:
	array.resize(dimensions.x * dimensions.y)
	array.fill(0)

static func make_int32_grid(initial_dimensions: Vector2i) -> PackedInt32Array:
	var grid = PackedInt32Array()
	make_grid(grid, initial_dimensions)
	return grid

static func make_byte_grid(initial_dimensions: Vector2i) -> PackedByteArray:
	var grid = PackedByteArray()
	make_grid(grid, initial_dimensions)
	return grid
