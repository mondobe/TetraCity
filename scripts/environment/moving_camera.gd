class_name MovingCamera
extends Camera2D
## The moving camera script is responsible for the placement of the camera in the
## World scene.

## The modes that the camera could be in.
enum CameraMode { GROUND, SKY }

## The speed at which the camera moves towards its target
@export var speed: float

## The amount by which the camera is allowed to move from the center of the screen
## in Ground View
@export var extent: float

## The position where the camera goes in Sky View
@export var sky_position: Vector2

## The mode the camera is currently in
@onready var _camera_mode: CameraMode

## Whether the camera is locked to the current mode.
## If the camera is locked, pressing TAB will not change the camera view.
@onready var locked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the user has pressed TAB, toggle between the ground and the sky view.
	if Input.is_action_just_pressed("ui_focus_next"):
		toggle_sky_and_ground_view()

	var target_pos: Vector2
	match get_camera_mode():
		# Ground view: set the target position to the mouse position (within
		# the specified extent) and move towards it
		CameraMode.GROUND:
			target_pos = get_global_mouse_position() - global_position
			if target_pos.length() > extent:
				target_pos = target_pos.normalized() * extent
		# Sky view: move towards the previously specified position
		CameraMode.SKY:
			target_pos = sky_position
	var delta_pos = target_pos - global_position
	translate(delta_pos * speed * delta)

## Called on pressing TAB. Name is self-explanatory
func toggle_sky_and_ground_view():
	if _camera_mode == CameraMode.GROUND:
		set_camera_mode_if_unlocked(CameraMode.SKY)
	else:
		set_camera_mode_if_unlocked(CameraMode.GROUND)

## The current camera mode
func get_camera_mode() -> CameraMode:
	return _camera_mode

## Sets the camera to the specified mode and locks it.
## Could be used for e.g. placing a piece.
func lock_to_camera_mode(mode: CameraMode) -> void:
	_camera_mode = mode
	locked = true

## Unlocks the camera so calling set_camera_mode_if_unlocked will move it
func unlock() -> void:
	locked = false

## If the camera is unlocked, sets it to the specified mode.
func set_camera_mode_if_unlocked(new_mode: CameraMode) -> void:
	if not locked:
		_camera_mode = new_mode
