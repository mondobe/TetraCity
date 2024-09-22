class_name BuildingVariation
extends Resource
## Some buildings (like the religious building) can have multiple sprites with
## different names but otherwise identical functionality. This resource holds any
## information that might change among these variations.

## The building's sprite.
@export var sprite: Texture2D

## The building's name.
@export var building_name: String

## The blueprint on which this variation is based.
@export var blueprint: BuildingBlueprint
