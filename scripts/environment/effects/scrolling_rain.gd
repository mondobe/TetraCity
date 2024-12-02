extends Sprite2D
## Responsible for the very basic "Scrolling rain" effect.
## The transform of the node itself isn't moved - instead, the sprite region
## being shown is moved, with the sprite mode set to "Repeat", so the rain
## appears to scroll indefinitely and wrap around.

## The amount by which the clouds move in the horizontal direction each frame
@export var drift: Vector2

# Called on start
func _ready() -> void:
	# Randomize the sprite position
	region_rect.position = Vector2(randf_range(0, 2000), randf_range(0, 1000))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	region_rect.position += drift
