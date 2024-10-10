class_name BuildingInfoBox
extends DialogueBox
## Represents a dialogue box that holds information about a building, including
## upgrades (if unlocked).

## The balloon that was clicked on to spawn this box.
var building: Building

## Initialize this dialogue box's values from a specific balloon.
func init_from_building(building: Building):
	self.building = building
	update_text()

func update_text() -> void:
	resize_borders(Vector2(300, 400))
	set_text("%s\n%s" % [
		building.variation.building_name,
		building.bonus.get_info_text()
	])
