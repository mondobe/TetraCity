extends Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self_modulate = Color(1, 1, 1, 0.3 + 0.1 * sin(Time.get_ticks_msec() * 0.004))
