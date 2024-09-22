class_name NpcDialogueBox
extends DialogueBox
## Represents a dialogue box that holds an NPC interaction, including buttons to
## buy a building or ignore the interaction.

## The balloon that was clicked on to spawn this box.
var balloon: Balloon

## The variation that the building being bought was based on.
var variation: BuildingVariation

## The button to ignore the interaction.
@onready var no_button: TextureButton = $NinePatchRect/NoButton

## The button to buy the building on offer.
@onready var yes_button: TextureButton = $NinePatchRect/YesButton

## Initialize this dialogue box's values from a specific balloon.
func init_from_balloon(balloon):
	self.balloon = balloon
	self.variation = balloon.variation

func _ready() -> void:
	resize_borders(Vector2(320, 300))
	set_text_no_resize("Test balloon NPC dialogue")

	no_button.pressed.connect(func(): ignore.emit())
	yes_button.pressed.connect(func(): buy.emit())

## Called when clicking the "buy" button
signal buy()

## Called when clicking the "ignore" button
signal ignore()
