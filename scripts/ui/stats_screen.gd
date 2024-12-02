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
Score: %d
Final Grade: %s
" %[SavedStats.getFinalBalance(),
SavedStats.getFinalFuel(),
SavedStats.getCoinsEarned(),
SavedStats.getBuildingsBought(),
SavedStats.getHighestCPD(),
SavedStats.getNaturalDisaster(),
get_score(),
get_grade()])

func get_score() -> float:
	var score: float = 0
	score += SavedStats.getFinalBalance()
	score += SavedStats.getFinalFuel() * 100
	score += SavedStats.getHighestCPD() * 4
	return score

func get_grade() -> String:
	var score: float = get_score()
	if score >= 3500:
		return "[color=#ff7d4f]S[/color]"
	if score >= 2500:
		return "[color=#fee34e]A[/color]"
	if score >= 2000:
		return "[color=#dff873]B[/color]"
	if score >= 1500:
		return "[color=#99f764]C[/color]"
	if score >= 800:
		return "[color=#5af4a5]D[/color]"
	if score >= 400:
		return "[color=#ddb2ef]E[/color]"
	return "[color=#362923]F[/color]"

func _on_play_again_button_pressed():
	var titleScreen: PackedScene = load("res://scenes/menus/title_screen.tscn")
	SavedStats.Clear()
	LevelLoader.load_level(titleScreen)
