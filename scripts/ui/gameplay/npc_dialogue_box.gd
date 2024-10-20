class_name NpcDialogueBox
extends DialogueBox
## Represents a dialogue box that holds an NPC interaction, including buttons to
## buy a building or ignore the interaction.

## The balloon that was clicked on to spawn this box.
var balloon: Balloon

## The variation that the building being bought was based on.
var variation: BuildingVariation

## The price of this building in coins
var price: int

## The button to ignore the interaction.
@onready var no_button: TextureButton = $NinePatchRect/NoButton

## The button to buy the building on offer.
@onready var yes_button: TextureButton = $NinePatchRect/YesButton

@onready var yes_button_text: Label = $NinePatchRect/YesButton/Label

var label_setting_red: LabelSettings

## Initialize this dialogue box's values from a specific balloon.
func init_from_balloon(balloon, canAfford):
	self.balloon = balloon
	self.variation = balloon.variation
	self.price = balloon.price
	if !canAfford:
		yes_button_text.set_label_settings(label_setting_red)
	else:
		yes_button_text.get_label_settings().set_font_color(Color(0, 0, 0))
	update_text()

func _ready() -> void:
	no_button.pressed.connect(func(): ignore.emit())
	yes_button.pressed.connect(func(): buy.emit())
	label_setting_red = yes_button_text.get_label_settings().duplicate()
	label_setting_red.set_font_color(Color(1, 0, 0))

func update_text() -> void:
	resize_borders(Vector2(320, 300))
	set_text_no_resize(
"%s
%s
Cost: %d coins"
		% [variation.building_name, variation.blueprint.description, price])

## Called when clicking the "buy" button
signal buy()

## Called when clicking the "ignore" button
signal ignore()
