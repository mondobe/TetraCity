extends Sprite2D

@export var drift_x: float
@export var drift_y_amp: float
@export var drift_y_freq: float

func _ready() -> void:
	region_rect.position = Vector2(randf_range(0, 2000), randf_range(0, 1000))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	region_rect.position.x += drift_x * delta
	region_rect.position.y = drift_y_amp * sin(Time.get_ticks_msec() * drift_y_freq)
