class_name GridClickControls
extends Node

@export var building_grid: BuildingGrid

@export var moving_camera: MovingCamera

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		var mouse_pos: Vector2 = moving_camera.get_global_mouse_position()
		var mouse_space: Vector2i = building_grid.global_coords_to_grid_space(mouse_pos)
		if building_grid.grid.contains(mouse_space):
			var mouse_building_index: int = building_grid.grid.at(mouse_space)
			if mouse_building_index > 0:
				var mouse_building: Building = building_grid.buildings[mouse_building_index - 1]
				print(mouse_building.variation.building_name)
