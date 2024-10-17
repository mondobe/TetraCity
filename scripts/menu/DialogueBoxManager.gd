extends Node

#cutscene should be more general. Can be 3 different forms. 

@export var _dialogue_box_spawner: CutsceneDialogBoxSpawner

@onready var textBox: CutsceneDialogueBox = null

@export var startConversation: Array[String]
@export var startImage: Array[Texture2D]
@export var startSpeaker: String

@export var endWinConversation: Array[String]
@export var endWinImage: Array[Texture2D]
@export var endWinSpeaker: String

@export var endLoseConversation: Array[String]
@export var endLoseImage: Array[Texture2D]
@export var endLoseSpeaker: String

@onready var conversation: Array[String]
@onready var image: Array[Texture2D]
@onready var exitScene: PackedScene

@onready var currentString: int = 0

@export var imageFrame: TextureRect

const _main_scene = preload("res://scenes/gameplay/world.tscn")
const _title_scene = preload("res://scenes/menus/title_screen.tscn")

func _ready():
	createScene("startCutscene")

func createScene(scene: String):
	var test = _dialogue_box_spawner.spawn_cutscene_box_at_screen()
	test.update_size()
	imageFrame.size = DisplayServer.window_get_size(0)
	if(scene == "endWinCutscene"):
		conversation = endWinConversation
		image = endWinImage
		test.set_speaker_text(endWinSpeaker)
		exitScene = _main_scene;
	elif(scene == "endLoseCutscene"):
		conversation = endLoseConversation
		image = endLoseImage
		test.set_speaker_tet(endLoseSpeaker)
		exitScene = _title_scene
	elif(scene == "startCutscene"):
		conversation = startConversation
		image = startImage
		test.set_speaker_text(startSpeaker)
		exitScene = _main_scene
	test.set_speaker_text(conversation[currentString]);
	imageFrame.texture = image[currentString]
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
			LevelLoader.load_level(exitScene)

