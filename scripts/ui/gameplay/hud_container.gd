class_name HudContainer
extends VBoxContainer

@onready var ascend_button = $AscendButton

@onready var descend_button = $DescendButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_camera_mode(mode: MovingCamera.CameraMode) -> void:
	if mode == MovingCamera.CameraMode.SKY:
		ascend_button.hide()
		descend_button.show()
	else:
		ascend_button.show()
		descend_button.hide()
