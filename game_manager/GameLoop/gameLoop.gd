extends Node

var last_day: int = -1 
@onready var enemy_handler = $Enemy_handler
var costumer: Inventory

func _ready() -> void:
	last_day = GameVariables.day  

func _process(delta: float) -> void:
	if GameVariables.day != last_day:
		last_day = GameVariables.day
		_on_day_changed(last_day)

func _on_night_start():
	print("Night has started")
	
func _on_day_changed(day: int) -> void:
	print("Day has changed to:", day)
	_update_game_state(day)
	GenerateMapVariables.spawn_chests()

func _update_game_state(day: int) -> void:
	print("Updating game state for day:", day)
	_update_player_stats(day)
	_reset_daily_quests()
	if day < 7:
		updatePods(day)

func _update_player_stats(day) -> void:
	pass

func _reset_daily_quests() -> void:
	print("Resetting daily quests for the new day")

func updatePods(day):
	match day:
		2:
			GenerateMapVariables.spawnPod(0)
		4:
			GenerateMapVariables.spawnPod(0)
		6:
			GenerateMapVariables.spawnPod(0)
