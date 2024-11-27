class_name Balloon
extends Node2D

## The blueprint on which this balloon's building is based.
var blueprint: BuildingBlueprint

## The variation on which this balloon's building is based.
var variation: BuildingVariation

## The moving camera.
var moving_camera: MovingCamera

## The price of the balloon's building in coins.
var price: int

## The number of days left in this balloon's lifetime.
var lifetime: int

## Reference to the grid containing the building
var grid: BuildingGrid

## The point to which the balloon is moving
var target_position: Vector2

## The area of this balloon that can be clicked.
@onready var click_area: Area2D = $HitboxArea

@onready var sprite: Sprite2D = $BuildingSprite

@onready var float_offset: float = randf_range(0, 2 * PI)

@onready var disappear_timer: float = 5

@onready var floating_away = false

func _ready() -> void:
	click_area.input_event.connect(click_input)
	click_area.mouse_entered.connect(
		func() -> void:
			sprite.self_modulate = Color(0.8, 0.8, 0.8)
	)
	click_area.mouse_exited.connect(
		func() -> void:
			sprite.self_modulate = Color.WHITE
	)

func _process(delta: float) -> void:
	var delta_x: float = target_position.x - global_position.x
	if abs(delta_x) > 2:
		var vel_x: float = clamp(delta_x * 0.02, -140, 140)
		global_position.x += vel_x
	global_position.y = target_position.y + sin(Time.get_ticks_msec() * 0.0015 + float_offset) * 1.2
	if floating_away:
		disappear_timer -= delta
		if disappear_timer < 0:
			queue_free()

func start_float_towards(pos: Vector2) -> void:
	var start_pos: Vector2 = Vector2(sign(pos.x) * 300, pos.y)
	global_position = start_pos
	target_position = pos

func float_away() -> void:
	floating_away = true
	var end_pos: Vector2 = Vector2(sign(target_position.x) * 300, target_position.y)
	target_position = end_pos
	click_area.queue_free()

## Initialize this balloon from a blueprint variation, setting the texture and
## other data.
func init_from_blueprint_variation(variation: BuildingVariation, grid: BuildingGrid) -> void:
	self.blueprint = variation.blueprint
	self.variation = variation
	self.lifetime = blueprint.balloon_lifetime
	sprite = $BuildingSprite
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

## Get the price after applying modifiers (Right now just the bank)
func adjusted_price() -> int:
	var scale:float = 1
	for building in grid.buildings:
		if building.bonus is Bank:
			scale *= building.bonus.get_scale_factor(blueprint)
	return price * scale

## Called when this balloon is clicked on (when eligible)
signal on_click()
