class_name SkyViewControls
extends Node

@export var _moving_camera : MovingCamera

@export var _camera_mode : MovingCamera.CameraMode

@export var _test_blueprints: Array[BuildingBlueprint]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_mouse") and _moving_camera._camera_mode == _camera_mode:
		var blueprint: BuildingBlueprint = _test_blueprints[randi_range(0, len(_test_blueprints) - 1)]
		var building_sprite = Sprite2D.new()
		building_sprite.texture = blueprint.sprite
		building_sprite.position = _moving_camera.get_global_mouse_position()
		add_child(building_sprite)
