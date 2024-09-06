extends Sprite2D
## Responsible for the very basic "Scrolling clouds" effect.
## The transform of the node itself isn't moved - instead, the sprite region
## being shown is moved, with the sprite mode set to "Repeat", so the clouds
## appear to scroll indefinitely and wrap around.

## The amount by which the clouds move in the horizontal direction each frame
@export var drift_x: float

## The extent to which the clouds drift vertically
@export var drift_y_amp: float

## The speed at which the clouds drift vertically
@export var drift_y_freq: float

# Called on start
func _ready() -> void:
	# Randomize the sprite position
	region_rect.position = Vector2(randf_range(0, 2000), randf_range(0, 1000))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	region_rect.position.x += drift_x * delta
	region_rect.position.y = drift_y_amp * sin(Time.get_ticks_msec() * drift_y_freq)
