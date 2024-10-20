class_name GridSfx
extends AudioStreamPlayer2D

@export var building_move: Array[AudioStream]

@export var gravity: AudioStream

@export var hard_drop: AudioStream

@export var settle: AudioStream

func play_building_move() -> void:
	stream = building_move.pick_random()
	play()

func play_gravity() -> void:
	stream = gravity
	play()

func play_hard_drop() -> void:
	stream = hard_drop
	play()

func play_settle() -> void:
	stream = settle
	play()
