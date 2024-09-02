class_name MovingCamera
extends Camera2D

enum CameraMode { GROUND, SKY }

@export var speed: float
@export var extent: float

@export var sky_position: Vector2

@onready var _camera_mode: CameraMode
@onready var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		toggle_sky_and_ground_view()

	var target_pos: Vector2
	match get_camera_mode():
		CameraMode.GROUND:
			target_pos = get_global_mouse_position() - global_position
			if target_pos.length() > extent:
				target_pos = target_pos.normalized() * extent
		CameraMode.SKY:
			target_pos = sky_position
	var delta_pos = target_pos - global_position
	translate(delta_pos * speed * delta)

func toggle_sky_and_ground_view():
	if _camera_mode == CameraMode.GROUND:
		set_camera_mode_if_unlocked(CameraMode.SKY)
	else:
		set_camera_mode_if_unlocked(CameraMode.GROUND)

func get_camera_mode() -> CameraMode:
	return _camera_mode

func lock_to_camera_mode(mode: CameraMode) -> void:
	_camera_mode = mode
	locked = true

func set_camera_mode_if_unlocked(new_mode: CameraMode) -> void:
	if not locked:
		_camera_mode = new_mode
