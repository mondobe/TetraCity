class_name SkyViewControls
extends Node

@export var _moving_camera : MovingCamera
@export var _dialogue_box_spawner: DialogueBoxSpawner

@export var _camera_mode : MovingCamera.CameraMode

@export var _test_blueprints: Array[BuildingBlueprint]

@export var _balloon: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_create_building") and _moving_camera._camera_mode == _camera_mode:
		spawn_balloon_at_cursor()

func spawn_balloon_at_cursor():
	var blueprint: BuildingBlueprint = _test_blueprints[randi_range(0, len(_test_blueprints) - 1)]
	var balloon: Balloon = _balloon.instantiate()
	balloon.init_from_blueprint(blueprint)
	balloon.position = _moving_camera.get_global_mouse_position()
	balloon.on_click.connect(func(): balloon_dialogue(balloon))
	add_child(balloon)

func balloon_dialogue(balloon: Balloon):
	print("Spawn dialogue")
	var dialogue_box_pos = (Vector2(80, 80)
		if balloon.global_position.x > _moving_camera.global_position.x
		else Vector2(560, 80))
	var box = _dialogue_box_spawner.spawn_npc_box_at_screen(dialogue_box_pos)
