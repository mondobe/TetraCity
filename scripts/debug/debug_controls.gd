class_name DebugControls
extends Node
## Allows the current level to be swapped out without custom UI. As more
## scenes are added, modify this node to add new hotkeys for them.
## This script shouldn't be used past M2 or so, once placeholder UI is in place.

## The list of hotkeys with corresponding scenes to load
@export var scene_keys: Array[DebugSceneHotkey]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Close the app if ESC is pressed (for convenience)
	# if Input.is_action_just_pressed("ui_cancel"):
		# get_tree().quit()

	# For each scene hotkey, test if SHIFT + the hotkey is pressed, then open
	# the scene
	if Input.is_key_pressed(KEY_SHIFT):
		for d in scene_keys:
			if Input.is_key_pressed(d.key):
				LevelLoader.load_level(d.scene)
