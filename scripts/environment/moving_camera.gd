class_name MovingCamera
extends Camera2D

enum CameraModes { GROUND, SKY }

const toggle_modes: Array[CameraModes] = [CameraModes.GROUND, CameraModes.SKY]

@export var speed: float
@export var extent: float

@export var sky_position: Vector2

@onready var _camera_mode_index: int = 0
func camera_mode() -> CameraModes:
	return toggle_modes[_camera_mode_index]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		_camera_mode_index = (_camera_mode_index + 1) % len(toggle_modes)

	var target_pos: Vector2
	match camera_mode():
		CameraModes.GROUND:
			target_pos = get_global_mouse_position() - global_position
			if target_pos.length() > extent:
				target_pos = target_pos.normalized() * extent
		CameraModes.SKY:
			target_pos = sky_position
	var delta_pos = target_pos - global_position
	translate(delta_pos * speed * delta)
