extends Node

var chest= preload("res://interaction/Prefabs/chest/chest.tscn")
var weapon_pod = preload("res://interaction/Prefabs/pods/weaponPod.tscn")

var last_day: int = -1 

func _ready() -> void:
	last_day = GameVariables.day  

func _process(delta: float) -> void:

	if GameVariables.day != last_day:
		last_day = GameVariables.day
		_on_day_changed(last_day)

func _on_day_changed(day: int) -> void:
	print("Day has changed to:", day)
	_update_game_state(day)
	GenerateMapVariables.spawn_objects(chest, 20, "chests", 10)

func _update_game_state(day: int) -> void:
	print("Updating game state for day:", day)
	_update_player_stats()
	_reset_daily_quests()
	
	if day < 7:
		updatePods(day)

func _update_player_stats() -> void:
	print("Updating player stats for the new day")

func _reset_daily_quests() -> void:
	print("Resetting daily quests for the new day")

func updatePods(day):
	match day:
		2:
			GenerateMapVariables.spawn_objects(weapon_pod, 20)
		4:
			GenerateMapVariables.spawn_objects(weapon_pod, 20)
		6:
			GenerateMapVariables.spawn_objects(weapon_pod, 20)
