class_name LightningStorm
extends Node

const splash_scene: PackedScene = preload("res://scenes/effects/lightning_storm/lightning_smash.tscn")
const bolt_scene: PackedScene = preload("res://scenes/effects/lightning_storm/lightning_strike.tscn")
const clouds_scene: PackedScene = preload("res://scenes/effects/acid_rain/acid_clouds.tscn")

var clouds: Sprite2D

const START_DAY: int = 45

var _world_stats: WorldStats

var _moving_camera: MovingCamera

var disaster_name = "Lightning Storm"

func init(world_stats: WorldStats) -> void:
	clouds = clouds_scene.instantiate()
	_world_stats = world_stats
	_moving_camera = world_stats.building_grid._moving_camera
	add_sibling(clouds)

func get_info_text(day: int) -> String:
	match day:
		START_DAY:
			return "Lightning strike incoming!"
		START_DAY - 1:
			return "Lightning Strike tomorrow! Your
highest building and any buildings below it will be destroyed!"
		var curr_day when START_DAY - curr_day <= 10 and START_DAY > curr_day:
			var days_left = START_DAY - curr_day
			return "Lightning Strike in %d days! Your
highest building and any buildings below it will be destroyed!" % days_left
		_:
			return ""

func on_new_day(day: int) -> void:
	if day <= START_DAY:
		var intensity: float = max((day + 5 - START_DAY) * 0.2, 0)
		clouds.self_modulate = Color(1, 1, 1, intensity)

		if day == START_DAY:
			lightning_strike()
	else:
		clouds.self_modulate = Color(1, 1, 1, 0)

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

	# Given some building, find the highest y coordinate (lowest y value) in the building
	var peak = func(building): return get_coords(building).map(func(vec): return vec.y).min()
	var tallest: Building = building_grid.buildings.reduce(func(high, curr): return high if peak.call(high) < peak.call(curr) else curr)

	# Chose our column to destroy
	var cols: Array[int] = []
	for curr: Vector2i in get_coords(tallest):
		if not curr.x in cols:
			cols.append(curr.x)
	if cols.is_empty():
		return
	var col: int = cols.pick_random()

	# Get array of buildings that contain the column
	var to_destroy: Array[Building] = building_grid.buildings.filter(func(curr):
		var has_col = col in get_coords(curr).map(func(vec): return vec.x)
		return has_col and (not curr.bonus is CityHall))
	# Use the splash scene for now
	building_grid.destroy_buildings(to_destroy, splash_scene)
	var bolt: AnimatedSprite2D = bolt_scene.instantiate()
	bolt.global_position = (building_grid.global_position
		+ Vector2(col + 0.5, peak.call(tallest)) * BuildingGrid.GRID_SPACE_SIZE)
	add_sibling(bolt)
	_moving_camera.shake(1)
