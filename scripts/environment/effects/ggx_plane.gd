class_name GGXPlane
extends AnimatedSprite2D

@export var speed = 400

@export var x_extent = 4000

func randomize_position() -> void:
	position = Vector2(x_extent, randf_range(100.0, -400.0))

func _ready() -> void:
	if Settings.demo != 1:
		queue_free()
	else:
		randomize_position()

func _process(delta: float) -> void:
	position += Vector2.LEFT * speed * delta
	if position.x < -x_extent:
		randomize_position()
