class_name GridClickControls
extends Node

@export var building_grid: BuildingGrid

@export var moving_camera: MovingCamera

@export var dialogue_box_spawner: DialogueBoxSpawner

@onready var current_info_box: BuildingInfoBox = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moving_camera.get_camera_mode() != MovingCamera.CameraMode.BUILDING \
			and current_info_box != null:
		remove_current_info_box()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		remove_current_info_box()
		var mouse_pos: Vector2 = moving_camera.get_global_mouse_position()
		var mouse_space: Vector2i = building_grid.global_coords_to_grid_space(mouse_pos)
		if building_grid.grid.contains(mouse_space):
			var mouse_building_index: int = building_grid.grid.at(mouse_space)
			if mouse_building_index > 0:
				var mouse_building: Building = building_grid.buildings[mouse_building_index - 1]
				click_on(mouse_building, mouse_pos)
	if event.is_action_pressed("ui_cancel"):
		remove_current_info_box()

func click_on(building: Building, pos: Vector2):
	current_info_box = dialogue_box_spawner.spawn_info_box_at_static(pos)
	current_info_box.init_from_building(building)
	moving_camera.look_at_building(building)

func remove_current_info_box():
	if current_info_box:
		current_info_box.queue_free()
	current_info_box = null
	if moving_camera.get_camera_mode() == MovingCamera.CameraMode.BUILDING:
		moving_camera.set_camera_mode_if_unlocked(MovingCamera.CameraMode.GROUND)

