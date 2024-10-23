extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = randi_range(0, sprite_frames.get_frame_count(animation))
	speed_scale = randf_range(0.7, 1.3)
	play()
