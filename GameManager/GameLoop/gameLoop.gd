extends Node

var last_day: int = -1 

func _ready() -> void:
	last_day = GameVariables.day  # Store the initial day value

func _process(delta: float) -> void:

	if GameVariables.day != last_day:
		last_day = GameVariables.day
		_on_day_changed(last_day)

func _on_day_changed(day: int) -> void:
	# Your game loop logic that should run when the day changes
	print("Day has changed to:", day)
	# Add your game logic here
	_update_game_state(day)
	GenerateMapVariables.spawn_chests()

func _update_game_state(day: int) -> void:
	# Implement game state updates for the new day
	print("Updating game state for day:", day)
	# Example: Increase player stats, reset daily quests, etc.
	_update_player_stats()
	_reset_daily_quests()

func _update_player_stats() -> void:
	print("Updating player stats for the new day")
	# Implement player stats update logic here

func _reset_daily_quests() -> void:
	print("Resetting daily quests for the new day")
	# Implement daily quest reset logic here
