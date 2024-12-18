extends Node

@export var _dialogue_box_spawner: CutsceneDialogBoxSpawner

@onready var cutscene: Cutscene = CutsceneLoader.current_cutscene

var text_box: CutsceneDialogueBox

@onready var current_frame: int = 0

@export var image_frame: TextureRect

func _ready():
	text_box = _dialogue_box_spawner.spawn_cutscene_box_at_screen()
	text_box.update_size()
	image_frame.size = get_window().size
	next_frame()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		next_frame()

func next_frame() -> void:
	if current_frame < cutscene.frames.size():
		apply_frame(cutscene.frames[current_frame])
		current_frame += 1
	else:
		LevelLoader.load_level(load(cutscene.next_level))

func apply_frame(frame: CutsceneFrame) -> void:
	text_box.set_speaker(frame.speaker)
	text_box.portrait.texture = frame.portrait
	image_frame.texture = frame.frame
	text_box.set_speaker_text(frame.dialogue)

