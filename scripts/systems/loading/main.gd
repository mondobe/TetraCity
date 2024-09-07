class_name Main
extends Node
## Initializes the basics of the game and loads the first level.

## The initial level we want to load when the game starts.
@export var _initial_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelLoader.load_level(_initial_scene)

