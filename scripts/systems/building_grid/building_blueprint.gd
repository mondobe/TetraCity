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

## The list of variations that can spawn of this building.
@export var variations: Array[String]

## The day on which this building can first arrive as a balloon
@export var first_spawning_day: int

## The number of days for which a balloon with this building lasts
@export var balloon_lifetime: int

## The probabilities that this building will spawn depending on the number of these
## buildings that are in the world.
## So, if there are no buildings in the world (on balloons or in the grid) at the
## start of a day, the building will spawn with probability probabilities[0].
@export var probabilities: Array[float]

## The price of this building on the day on which it can first appear.
@export var starting_price: float

## The price increase of this building per day.
@export var daily_increase: float
