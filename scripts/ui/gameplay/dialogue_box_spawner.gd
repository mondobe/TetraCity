class_name DialogueBoxSpawner
extends Node

@export var dialogue_box: PackedScene
@export var npc_dialogue_box: PackedScene
@export var building_info_box: PackedScene

@export var small_pixel_ui_layer: CanvasLayer
@export var static_small_pixel_ui_layer: CanvasLayer

## Spawns and returns a dialogue box at the given position.
func spawn_box_at(pos: Vector2, scene: PackedScene) -> DialogueBox:
	var box: DialogueBox = scene.instantiate()
	var canvas_layer: CanvasLayer = small_pixel_ui_layer
	canvas_layer.add_child(box)
	var pos_screen = get_viewport().canvas_transform * pos
	box.position = canvas_layer.transform.affine_inverse() * pos_screen
	return box

## Spawns and returns a dialogue box at the given screen position.
func spawn_box_at_screen(pos_screen: Vector2, scene: PackedScene) -> DialogueBox:
	var box: DialogueBox = scene.instantiate()
	var canvas_layer: CanvasLayer = small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = pos_screen
	return box

## Spawns and returns an NPC dialogue box at the given screen position.
func spawn_npc_box_at_screen(pos_screen: Vector2) -> NpcDialogueBox:
	return spawn_box_at_screen(pos_screen, npc_dialogue_box)

## Spawns and returns a dialogue box at the given position in the Static UI layer.
func spawn_box_at_static(pos: Vector2, scene: PackedScene) -> DialogueBox:
	var box: DialogueBox = scene.instantiate()
	var canvas_layer: CanvasLayer = static_small_pixel_ui_layer
	canvas_layer.add_child(box)
	box.position = canvas_layer.transform.affine_inverse() * pos
	return box

## Spawns and returns a building info box at the given position.
func spawn_info_box_at_static(pos: Vector2) -> BuildingInfoBox:
	return spawn_box_at_static(pos, building_info_box)
