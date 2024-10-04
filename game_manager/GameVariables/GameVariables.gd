extends Node

var is_night = false

var GameDifficulty = "easy"
var difficultyVariable = 1

var day: int = 0


func _ready():
	setUpGameDifficulty()


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
