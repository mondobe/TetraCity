class_name DialogueBoxSpawner
extends Node

@export var dialogue_box: PackedScene
@export var npc_dialogue_box: PackedScene
@export var building_info_box: PackedScene

@export var small_pixel_ui_layer: CanvasLayer
@export var static_small_pixel_ui_layer: CanvasLayer

# Called when the node enters the scene tree for the first time.
func spawn_box_at(pos: Vector2) -> DialogueBox:
	var box: DialogueBox = dialogue_box.instantiate()
	var canvas_layer: CanvasLayer = small_pixel_ui_layer
	canvas_layer.add_child(box)
	var pos_screen = get_viewport().canvas_transform * pos
	box.position = canvas_layer.transform.affine_inverse() * pos_screen
	return box

func spawn_box_at_screen(pos_screen: Vector2) -> DialogueBox:
	var box: DialogueBox = dialogue_box.instantiate()
	var canvas_layer: CanvasLayer = small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = pos_screen
	return box

func spawn_npc_box_at_screen(pos_screen: Vector2) -> NpcDialogueBox:
	var box: NpcDialogueBox = npc_dialogue_box.instantiate()
	var canvas_layer: CanvasLayer = small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = pos_screen
	return box

func spawn_box_at_static(pos: Vector2) -> DialogueBox:
	var box: DialogueBox = dialogue_box.instantiate()
	var canvas_layer: CanvasLayer = static_small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = canvas_layer.transform.affine_inverse() * pos
	return box

func spawn_info_box_at_static(pos: Vector2) -> BuildingInfoBox:
	var box: BuildingInfoBox = building_info_box.instantiate()
	var canvas_layer: CanvasLayer = static_small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = canvas_layer.transform.affine_inverse() * pos
	return box

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
