extends Node

var finalBalance: int
var fuelRemaining: int
var coinsEarned: int
var buildingsBought: int
var highestCPD: int
var disaster: String

func incrementBuildingBought(increase: int):
	buildingsBought += increase

func setFinalBalance(balance: int):
	finalBalance = balance;

func setFinalFuel(fuel: int):
	fuelRemaining = fuel

func incrementCoinsEarned(coins: int):
	coinsEarned += coins

func printCoinsEarned():
	print("coins earned ", coinsEarned)

func getFinalBalance():
	return finalBalance

func getBuildingsBought():
	return buildingsBought

func getCoinsEarned():
	return coinsEarned

func getFinalFuel():
	return fuelRemaining

func setMaxCPD(inputCPD: int):
	if (inputCPD > highestCPD):
		highestCPD = inputCPD

func getHighestCPD():
	return highestCPD

#Takes the natural disaster as the file path
func setNaturalDisaster(inputDisaster: String):
	disaster = inputDisaster

func getNaturalDisaster():
	return disaster

func Clear():
	finalBalance = 0
	buildingsBought = 0
	coinsEarned = 0
	fuelRemaining = 0
