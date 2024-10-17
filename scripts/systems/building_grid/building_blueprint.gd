class_name BuildingBlueprint
extends Resource
## Holds the unique information about a building type.

## The script of the bonus that the building uses.
@export var bonus: Script

## The squares that make up the building, written as a "human-readable" string.
## For example, a T-block with a 3x3 bounding box would have:
## .O.
## OOO
## ...
@export_multiline var squares: String

## The coordinates of the building's center square.
@export var center_coords: Vector2i

## See the [enum Building.CenterMode] docs
@export var center_mode: Building.CenterMode

## See the [enum Building.KickMode] docs
@export var kick_mode: Building.KickMode

## The building's description
@export_multiline var description: String
