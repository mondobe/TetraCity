class_name SkyViewControls
extends Node
## Controls the process of interacting with NPCs in Sky View and buying buildings.

## The moving camera.
@export var _moving_camera: MovingCamera

## The node responsible for spawning dialogue boxes.
@export var _dialogue_box_spawner: DialogueBoxSpawner

## The building grid.
@export var _building_grid: BuildingGrid

## The building variations that can randomly spawn upon pressing SPACE.
@export var _test_variations: Array[BuildingVariation]

## The scene holding the balloon.
@export var _balloon: PackedScene

## The NPC dialogue box being shown currently.
@onready var _npc_dialogue_box: NpcDialogueBox = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_create_building") \
		and _moving_camera._camera_mode == MovingCamera.CameraMode.SKY:
		spawn_balloon_at_cursor()

## Spawn a balloon at the cursor position.
func spawn_balloon_at_cursor() -> void:
	var variation: BuildingVariation = _test_variations[randi_range(0, len(_test_variations) - 1)]
	var balloon: Balloon = _balloon.instantiate()
	balloon.init_from_blueprint_variation(variation)
	balloon.position = _moving_camera.get_global_mouse_position()
	balloon.on_click.connect(func(): balloon_dialogue(balloon))
	balloon.moving_camera = _moving_camera
	add_child(balloon)

## Spawn a dialogue box (called when clicking on a balloon).
func balloon_dialogue(balloon: Balloon) -> void:
	if _npc_dialogue_box:
		return

	_moving_camera.lock_to_camera_mode(MovingCamera.CameraMode.SKY)
	var dialogue_box_pos = (Vector2(80, 80)
		if balloon.global_position.x > _moving_camera.global_position.x
		else Vector2(560, 80))
	var box = _dialogue_box_spawner.spawn_npc_box_at_screen(dialogue_box_pos)
	box.init_from_balloon(balloon)
	box.buy.connect(func(): buy_button(box))
	box.ignore.connect(func(): ignore_button(box))
	_npc_dialogue_box = box

## Buy a building (called upon pressing the corresponding button)
func buy_button(box: NpcDialogueBox) -> void:
	_moving_camera.lock_to_camera_mode(MovingCamera.CameraMode.GROUND)
	_building_grid.make_and_place(box.variation)
	box.balloon.queue_free()
	box.queue_free()

## Hide an undesirable NPC dialogue box (called upon pressing "No, thanks")
func ignore_button(box: NpcDialogueBox) -> void:
	_npc_dialogue_box = null
	box.queue_free()

## Finish placing a bought building
func done_placing() -> void:
	_moving_camera.unlock()
	_npc_dialogue_box = null
