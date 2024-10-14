class_name CutsceneDialogueBox
extends DialogueBox


@onready var nameLabel: RichTextLabel = $CutsceneName/NameLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_speaker_text(text: String) -> void:
	set_text_no_resize(text)

func set_speaker(text: String) -> void:
	nameLabel.text = text
