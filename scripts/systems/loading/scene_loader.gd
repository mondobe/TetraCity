class_name SceneLoader
extends Node

@export var _initial_scene: PackedScene

var _loaded_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scene(_initial_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Load the given scene, replacing the currently loaded one
func load_scene(scene: PackedScene) -> void:
	if _loaded_scene:
		_loaded_scene.queue_free()
	if scene:
		var new_child = scene.instantiate()
		add_child(new_child)
		_loaded_scene = new_child
	else:
		_loaded_scene = null
