extends Node

signal money_updated(new_money: int)

var player_money: int = 1000:
	get: return player_money
	set(value):
		player_money = value
		money_updated.emit(player_money)
		print("Player money has been updated: ", player_money)
		
var GameDifficulty = "easy"
var difficultyVariable = 1

var day: int = 0

func _ready():
	setUpGameDifficulty()

func increasePlayerMoney(amount):
	player_money+=amount
	money_updated.emit(player_money)
	
func decreasePlayerMoney(amount):
	player_money-=amount
	money_updated.emit(player_money)

func reparirShip():
	pass

func setUpGameDifficulty():
		match GameDifficulty:
			"easy": 
				difficultyVariable = 1
			"medium": 
				difficultyVariable = 2
			"hard": 
				difficultyVariable = 3
				
