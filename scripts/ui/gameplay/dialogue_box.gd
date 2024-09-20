class_name DialogueBox
extends Control

@export var padding: float
@onready var rect: NinePatchRect = $NinePatchRect
@onready var label: RichTextLabel = $NinePatchRect/RichTextLabel

func _ready() -> void:
	pass

func _padding() -> Vector2:
	return Vector2(padding, padding)

func resize_content(size: Vector2) -> void:
	label.position = Vector2(13, 13) + _padding()
	rect.size = size + Vector2(26, 26) + 2 * _padding()
	label.size = size
	self.size = rect.size

func resize_borders(size: Vector2) -> void:
	resize_content(size - Vector2(26, 26))

func set_border_width(width: float) -> void:
	resize_borders(Vector2(width, rect.size.y))

func set_text(text: String) -> void:
	label.text = text
	var text_width = label.get_content_width()
	var text_height = label.get_content_height()
	resize_content(Vector2(text_width, text_height))

func set_text_no_resize(text: String) -> void:
	label.text = text
