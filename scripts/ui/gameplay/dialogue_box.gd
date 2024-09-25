class_name DialogueBox
extends Control
## Contains a dialogue box with an expanding rectangle and a text label.

## The text padding of this box (left, top, right, bottom).
@export var padding: Vector4

## The expanding rectangle that holds the content of the box.
@onready var rect: NinePatchRect = $NinePatchRect

## The box's text.
@onready var label: RichTextLabel = $NinePatchRect/RichTextLabel

## Resize this box's text label to the specified size.
func resize_content(size: Vector2) -> void:
	label.position = Vector2(13, 13) + Vector2(padding.x, padding.y)
	rect.size = size + Vector2(26 + padding.x + padding.z, 26 + padding.y + padding.w)
	label.size = size
	self.size = rect.size

## Resize this box's borders to the specified size.
func resize_borders(size: Vector2) -> void:
	resize_content(size - Vector2(26 - padding.x - padding.z, 26 - padding.y - padding.w))

## Set the width of this box's borders to the specified size.
func set_border_width(width: float) -> void:
	resize_borders(Vector2(width, rect.size.y))

## Set this box's text to the specified string and resize the box to fit.
func set_text(text: String) -> void:
	label.text = text
	var text_width = label.get_content_width()
	var text_height = label.get_content_height()
	resize_content(Vector2(text_width, text_height))

## Set this box's text to the specified string.
func set_text_no_resize(text: String) -> void:
	label.text = text
