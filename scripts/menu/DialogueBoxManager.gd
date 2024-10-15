extends Node

@export var _dialogue_box_spawner: CutsceneDialogBoxSpawner

@onready var textBox: CutsceneDialogueBox = null

@export var conversation: Array[String]

@onready var currentString: int = 0

# Called when the node enters the scene tree for the first time.
# 1920 x 1080
# 934 x 100
func _ready():
	var test = _dialogue_box_spawner.spawn_cutscene_box_at_screen(Vector2(0, 439))
	test.set_speaker_text(conversation[currentString]);
	test.set_speaker("Godot")
	textBox = test
	
func updateTextbox():
	textBox.set_speaker_text(conversation[currentString]);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("left_mouse")):
		currentString += 1
		if(currentString < conversation.size()):
			updateTextbox()
