extends Node

@export var is_sfx: bool

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vol = Settings.sfx_vol if is_sfx else Settings.music_vol
	parent.volume_db = log(vol) * 10

