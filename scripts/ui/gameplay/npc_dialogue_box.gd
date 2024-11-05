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

## The number of remining days for which this building will be available
var lifetime: int

## The button to ignore the interaction.
@onready var no_button: TextureButton = $NinePatchRect/NoButton

## The button to buy the building on offer.
@onready var yes_button: TextureButton = $NinePatchRect/YesButton

@onready var yes_button_text: Label = $NinePatchRect/YesButton/Label

#text which displays the NPC's name
@onready var NPCLabel: RichTextLabel = $NinePatchRect/NPCName/NameLabel

#Texture rectangle which displays the mugshot of the NPC
@onready var NPCPicture: TextureRect = $NinePatchRect/NinePatchRect/TextureRect

@onready var dialogue_text: RichTextLabel = $NinePatchRect/NPCDialogueLabel

@onready var building_info_text: RichTextLabel = $NinePatchRect/BuildingInfoLabel


## Initialize this dialogue box's values from a specific balloon.
func init_from_balloon(balloon):
	self.balloon = balloon
	self.variation = balloon.variation
	self.price = balloon.adjusted_price()
	self.lifetime = balloon.lifetime
	if price > balloon.grid.world_stats.coins:
		yes_button.hide()
	update_text()

func _ready() -> void:
	no_button.pressed.connect(func(): ignore.emit())
	yes_button.pressed.connect(func(): buy.emit())

func update_text() -> void:
	var randomIndex = randi() % variation.NPCDialog.size()
	NPCPicture.texture = variation.NPCImage
	NPCLabel.text = variation.NPCName
	dialogue_text.text = variation.NPCDialog[randomIndex]
	var lifetime_line: String = (("Last day to buy!" if lifetime == 1
		else ("%d days left to buy" % lifetime) if lifetime < 100
		else ""))
	var cost_suffix = "(Can't afford!)" if price > balloon.grid.world_stats.coins else ""
	building_info_text.text = (
"%s

%s

Cost: %d coins %s

%s"
		% [variation.building_name, variation.blueprint.description, price, cost_suffix, lifetime_line])

## Called when clicking the "buy" button
signal buy()

## Called when clicking the "ignore" button
signal ignore()
