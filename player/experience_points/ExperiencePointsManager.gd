extends Node
class_name ExperiencePointsManager

# Declare the signal to notify when experience or level changes
signal experience_updated

# Variables to store experience and level
var experience_points: int = 0   # Tracks the player's current experience points.
var current_level: int = 1       # Tracks the player's current level.
var total_amount_of_experience_points: int = experience_points

var experience_needed_level_up: int = 0   # The total experience points needed to reach the next level.

var base_xp: float = 10         # A base value used in the experience calculation formula, acting as a multiplier for each level's XP requirement.
var curve_steepness: float = 500 # A factor used to determine how much the XP requirement increases with each level, controlling the difficulty curve.

func _ready() -> void:
	experience_needed_level_up = get_experience_needed_for_next_level()
	print("Have ", experience_points, " and needs ", experience_needed_level_up)

func add_experience(points: int) -> void:
	if points < 0:
		print("Cannot add negative experience.")
		return

	experience_points += points
	total_amount_of_experience_points += points
	# Emit the signal to notify listeners (like UI)
	experience_updated.emit()
	check_level_up()


func check_level_up() -> void:
	while experience_points >= experience_needed_level_up:
		level_up()


func level_up() -> void:
	current_level += 1
	experience_points -= experience_needed_level_up
	experience_needed_level_up = get_experience_needed_for_next_level()

	# Notify that the player leveled up
	print("Leveled up! New level: ", current_level)
	print("Experience needed for next level: ", experience_needed_level_up)

	experience_updated.emit()

func get_experience_needed_for_next_level() -> int:
	return calculate_experience_needed(current_level)

func calculate_experience_needed(level: int) -> int:
	return level * 400#int(base_xp * level + log(level + 1) * curve_steepness)

func get_experience_needed_from_start_to_this(level: int) -> int:
	var total_experience: int = 0
	
	# Loop through each level from 1 to the specified level (inclusive)
	for lvl in range(1, level + 1):
		total_experience += calculate_experience_needed(lvl)
		
	return total_experience

func get_current_level() -> int:
	return current_level

func get_experience_points() -> int:
	return experience_points

func get_experience_needed_to_next_level() -> int:
	return experience_needed_level_up

func get_total_amount_of_experience_points() -> int:
	return total_amount_of_experience_points
