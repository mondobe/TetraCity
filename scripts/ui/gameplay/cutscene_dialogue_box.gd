class_name CutsceneDialogueBox
extends DialogueBox


@onready var nameLabel: RichTextLabel = $CutsceneName/NameLabel
@onready var nameContainer: NinePatchRect = $CutsceneName
@onready var portrait: TextureRect = $TextureRect
@onready var proportion: Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_speaker_text(text: String) -> void:
	set_text_no_resize(text)

func set_speaker(text: String) -> void:
	nameLabel.text = text
	
func update_size():
	var yScale = (DisplayServer.window_get_size(0).y) / 5
	var xScale = DisplayServer.window_get_size(0).x 
	portrait.size = Vector2(yScale, yScale)
	portrait.position = Vector2(0, yScale * 5 - yScale)
	resize_borders(Vector2(xScale - yScale, yScale))
	rect.position = Vector2(yScale, (yScale * 5) - yScale)
	label.add_theme_font_size_override("normal_font_size", 55)
	nameContainer.size = Vector2(yScale, rect.size.y / 3)
	nameContainer.position = Vector2(yScale, yScale * 5 - yScale - nameContainer.size.y / 2)
	nameLabel.add_theme_font_size_override("normal_font_size", 40)
	label.position = Vector2(label.position.x, label.position.y + nameContainer.size.y / 2)
