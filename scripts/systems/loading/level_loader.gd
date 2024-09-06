class_name LevelLoader
extends Node
## The level loader is responsible for loading scenes, but not just any scenes.
## The level loader makes it easier to load and unload game state scenes, like
## the title screen, main world, et cetera. Don't use it to instantiate
## buildings!!

## The initial level we want to load when the game starts.
@export var _initial_scene: PackedScene

## The currently loaded level.
var _loaded_scene: Node

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scene(_initial_scene)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Loads the given scene, replacing the currently loaded one.
func load_scene(scene: PackedScene) -> void:
	# If there's a scene already loaded, destroy it.
	if _loaded_scene:
		_loaded_scene.queue_free()

	# If the scene exists, instiantiate it and load it.
	if scene:
		var new_child = scene.instantiate()
		add_child(new_child)
		_loaded_scene = new_child
	# If the scene doesn't exist, load a null scene.
	else:
		_loaded_scene = null
