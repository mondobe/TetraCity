extends Node

@onready var text = $StatsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	text.text = ("Final Coin Balance: [color=#f3e060]%s[/color]
Fuel Remaining: [color=#f3e060]%s[/color]
Total Coins Earned: [color=#f3e060]%s[/color]
Buildings Bought: [color=#f3e060]%s[/color]
Highest CPD: [color=#f3e060]%s[/color]
Natural Disaster: %s
" %[SavedStats.getFinalBalance(),
SavedStats.getFinalFuel(),
SavedStats.getCoinsEarned(),
SavedStats.getBuildingsBought(),
SavedStats.getHighestCPD(),
SavedStats.getNaturalDisaster()])


func _on_play_again_button_pressed():
	var titleScreen: PackedScene = load("res://scenes/menus/title_screen.tscn")
	SavedStats.Clear()
	LevelLoader.load_level(titleScreen)
