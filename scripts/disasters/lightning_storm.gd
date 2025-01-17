class_name LightningStorm
extends Node

const splash_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_splash.tscn")

const START_DAY: int = 45

var _world_stats: WorldStats

func init(world_stats: WorldStats) -> void:
	_world_stats = world_stats

func get_info_text(day: int) -> String:
	match day:
		START_DAY:
			return "Lightning strike incoming!"
		var curr_day when START_DAY - curr_day <= 10:
			var days_left = START_DAY - curr_day
			return "Lightning Strike in %d days! Your 
highest building and any buildings below it will be destroyed!" % days_left
		_:
			return ""

func on_new_day(day: int) -> void:
	# Probably add visual effects based on day later
	if day == START_DAY:
		lightning_strike()

# Given some building, return an array of all grid coordinates in the building
func get_coords(building: Building) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for x: int in range(building.grid.dimensions.x):
		for y: int in range(building.grid.dimensions.y):
			var xy: Vector2i = Vector2i(x, y)
			if building.grid.at(xy) == 1:
				out.append(xy + building.pos_coords)
	return out

func lightning_strike() -> void:
	var building_grid: BuildingGrid = get_parent().building_grid
	if building_grid.buildings.is_empty():
		return

	# Given some building, find the highest y coordinate (lowest y value) in the building
	var peak = func(building): return get_coords(building).map(func(vec): return vec.y).min()
	var tallest: Building = building_grid.buildings.reduce(func(high, curr): return high if peak.call(high) < peak.call(curr) else curr)

	# Chose our column to destroy
	var cols: Array[int] = []
	for curr: int in get_coords(tallest):
		if not curr.x in cols:
			cols.append(curr.x)
	cols.sort()
	var col: int = cols[cols.size() / 2]

	# Get array of buildings that contain the column
	var to_destroy: Array[Building] = building_grid.buildings.filter(func(curr): 
		var has_col = col in get_coords(curr).map(func(vec): return vec.x)
		return has_col and (not curr.bonus is CityHall))
	# Use the splash scene for now
	building_grid.destroy_buildings(to_destroy, splash_scene)
