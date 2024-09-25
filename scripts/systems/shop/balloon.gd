class_name Balloon
extends Node2D

## The blueprint on which this balloon's building is based.
var blueprint: BuildingBlueprint

## The variation on which this balloon's building is based.
var variation: BuildingVariation

## The moving camera.
var moving_camera: MovingCamera

## The area of this balloon that can be clicked.
@onready var click_area: Area2D = $HitboxArea

func _ready() -> void:
	click_area.input_event.connect(click_input)

## Initialize this balloon from a blueprint variation, setting the texture and
## other data.
func init_from_blueprint_variation(variation: BuildingVariation) -> void:
	self.blueprint = variation.blueprint
	self.variation = variation
	var sprite = $BuildingSprite
	sprite.texture = variation.sprite

## Called when this balloon is clicked on (to initialize an interaction)
func click_input(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if moving_camera.get_camera_mode() != MovingCamera.CameraMode.SKY:
		return
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT \
			and mouse_event.is_pressed():
			on_click.emit()

## Called when this balloon is clicked on (when eligible)
signal on_click()
