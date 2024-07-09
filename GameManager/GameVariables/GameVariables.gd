extends Node

var GameDifficulty = "easy"
var difficultyVariable = 1

var day: int = 0

var meleeUpgrade = 1
var rangeUpgrade = 1
var towerUpgrade = 1
var shipUpgrade = 1

func _ready():
	setUpGameDifficulty()
func getCostOfUpgrade(type):
	match type:
		"meleeUpgrade": 
			return meleeUpgrade*4
		"rangeUpgrade": 
			return rangeUpgrade*4
		"towerUpgrade": 
			return towerUpgrade*4
		"shipUpgrade": 
			return shipUpgrade*4
			
func upgradeFromShip(type):
		match type:
			"meleeUpgrade": 
				meleeUpgrade+=difficultyVariable
			"rangeUpgrade": 
				rangeUpgrade+=difficultyVariable
			"towerUpgrade": 
				towerUpgrade+=difficultyVariable
			"shipUpgrade": 
				shipUpgrade+=difficultyVariable
				
func setUpGameDifficulty():
		match GameDifficulty:
			"easy": 
				difficultyVariable = 1
			"medium": 
				difficultyVariable = 2
			"hard": 
				difficultyVariable = 3
				

