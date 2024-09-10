extends Node
var player_money: int = 1000:
	get: return player_money
	set(value):
		player_money = value
		print("Player money has been updated: ", player_money)
		
var GameDifficulty = "easy"
var difficultyVariable = 1

var day: int = 0


func _ready():
	setUpGameDifficulty()

func increasePlayerMoney(amount):
	player_money+=amount
func decreasePlayerMoney(amount):
	player_money-=amount


func setUpGameDifficulty():
		match GameDifficulty:
			"easy": 
				difficultyVariable = 1
			"medium": 
				difficultyVariable = 2
			"hard": 
				difficultyVariable = 3
				
