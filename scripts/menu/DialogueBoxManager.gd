extends Node

@export var _dialogue_box_spawner: CutsceneDialogBoxSpawner

@onready var textBox: CutsceneDialogueBox = null

@export var conversation: Array[String]

@export var image: Array[Texture2D]

@onready var currentString: int = 0

@export var imageFrame: TextureRect

# Called when the node enters the scene tree for the first time.
# 1920 x 1080
# 934 x 100
func _ready():
	var test = _dialogue_box_spawner.spawn_cutscene_box_at_screen()
	test.update_size()
	test.set_speaker_text(conversation[currentString]);
	imageFrame.texture = image[currentString]
	imageFrame.size = DisplayServer.window_get_size(0)
	test.set_speaker("Godot")
	textBox = test
	
func updateTextbox():
	textBox.set_speaker_text(conversation[currentString]);
	imageFrame.texture = image[currentString]

func _input(event):
	if(Input.is_anything_pressed()):
		currentString += 1
		if(currentString < conversation.size()):
			updateTextbox()
		else:
			pass
			#Exit the cutscene scene

