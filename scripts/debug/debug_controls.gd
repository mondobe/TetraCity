class_name DebugControls
extends Node

@export var scene_keys: Array[DebugSceneHotkey]

@onready var _main: Main = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_key_pressed(KEY_SHIFT):
		for d in scene_keys:
			if Input.is_key_pressed(d.key):
				_main.scene_loader.load_scene(d.scene)
