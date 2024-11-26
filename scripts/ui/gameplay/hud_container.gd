class_name HudContainer
extends VBoxContainer

@onready var ascend_button = $AscendButton

@onready var descend_button = $DescendButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(camera: MovingCamera) -> void:
	if camera.locked:
		ascend_button.hide()
		descend_button.hide()
	elif camera.get_camera_mode() == MovingCamera.CameraMode.SKY:
		ascend_button.hide()
		descend_button.show()
	else:
		ascend_button.show()
		descend_button.hide()
