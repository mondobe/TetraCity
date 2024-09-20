class_name Balloon
extends Node2D

var blueprint: BuildingBlueprint
@onready var click_area: Area2D = $HitboxArea

func _ready() -> void:
	click_area.input_event.connect(click_input)

func init_from_blueprint(blueprint: BuildingBlueprint) -> void:
	self.blueprint = blueprint
	var sprite = $BuildingSprite
	sprite.texture = blueprint.sprite

func click_input(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT \
			and mouse_event.is_pressed():
			on_click.emit()

signal on_click()
