extends Node
var player_money = 1000
var GameDifficulty = "easy"
var difficultyVariable = 1

var day: int = 0


func _ready():
	setUpGameDifficulty()

func increasePlayerMoney(amount):
	player_money+=amount
	
func decreasePlayerMoney(amount):
	player_money-=amount

func getPlayerMoney():
	return player_money

func upgradeFromWeaponPod(type, upg_tier):
	match type:
		"Pistols":
			return
		"Shotguns":
			return
		"Assault_Rifles":
			return
		"Machine_Guns":
			return
		"LaserGuns":
			return
		"Snipers":
			return
	return

func setUpGameDifficulty():
		match GameDifficulty:
			"easy": 
				difficultyVariable = 1
			"medium": 
				difficultyVariable = 2
			"hard": 
				difficultyVariable = 3
				
