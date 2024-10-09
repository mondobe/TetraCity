class_name SolarFarm
extends Node

func get_bonus() -> BuildingBonus:
	var building: Building = get_parent()
	var building_grid: BuildingGrid = building.building_grid

	# Only add fuel if the day is a multiple of 3 (for balance reasons)
	if building_grid.world_stats.day % 3 == 0:
		# Loop through all squares in the bounding box
		for x: int in range(building.grid.dimensions.x):
			for y: int in range(building.grid.dimensions.y):
				var xy: Vector2i = Vector2i(x, y)
				# If there is a building square here...
				if building.grid.at(xy) == 1:
					var grid_xy: Vector2i = building.pos_coords + xy
					# If the square gets sun, add fuel
					if test_coord_gets_sun(grid_xy + Vector2i.UP):
						return BuildingBonus.new().with_fuel(1)
	return BuildingBonus.new()

# Recursively tests if a square on the grid is blocked by another building above it
func test_coord_gets_sun(coord: Vector2i) -> bool:
	print("Testing %s" % coord)
	var building_grid: BuildingGrid = get_parent().building_grid
	# If we reach the top of the grid, nothing has blocked us
	if not building_grid.grid.contains(coord):
		return true
	# If there's no building here, try the square above
	elif building_grid.grid.at(coord) == 0:
		return test_coord_gets_sun(coord + Vector2i.UP)
	# There's a building blocking the square
	else:
		return false
