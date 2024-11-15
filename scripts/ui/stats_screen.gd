extends Node

@onready var text = $StatsLabel

const titleScreen: PackedScene = preload("res://scenes/gameplay/world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	text.text = ("Final Coin Balance: %s coins
Fuel Remaining: %s
Total Coins Earned: %s coins
Buildings Bought: %s
Highest CPD: %s
Natural Disaster: %s
" %[SavedStats.getFinalBalance(), 
SavedStats.getFinalFuel(), 
SavedStats.getCoinsEarned(), 
SavedStats.getBuildingsBought(),
SavedStats.getHighestCPD(),
SavedStats.getNaturalDisaster()])


func _on_play_again_button_pressed():
	SavedStats.Clear()
	LevelLoader.load_level(titleScreen)
