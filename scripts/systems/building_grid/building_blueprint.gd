class_name BuildingBlueprint
extends Resource
## Holds the unique information about a building type.

## The script of the bonus that the building uses.
@export var bonus: Script

## The building's name
@export var name: String

## The building's description
@export_multiline var description: String

## The list of variations that can spawn of this building.
@export var variations: Array[String]

## The day on which this building can first arrive as a balloon
@export var first_spawning_day: int

## The number of days for which a balloon with this building lasts
@export var balloon_lifetime: int

## The price of this building on the day on which it can first appear.
@export var starting_price: float

## The price increase of this building per day, as a percentage of the current price.
@export var daily_increase: float

## A multiplier applied to the day, whose product is added linearly to the current price.
@export var day_multiplier: float
