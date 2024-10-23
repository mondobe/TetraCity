extends Label

@export var time_alive: float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_alive -= delta
	if time_alive < 0:
		queue_free()
