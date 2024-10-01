extends Node
class_name ExperiencePointsManager

# Declare the signal to notify when experience or level changes
signal experience_updated

# Variables to store experience and level
var experience_points: int = 128
var current_level: int = 0
var experience_needed: int = 400

var base_xp: float = experience_needed  
var curve_steepness: float = 500


func add_experience(points: int) -> void:
	if points < 0:
		print("Cannot add negative experience.")
		return
	
	experience_points += points
	print("Added ", points, " experience points. Total: ", experience_points)
	
	# Emit the signal to notify listeners (like UI)
	emit_signal("experience_updated")
	check_level_up()

func check_level_up() -> void:
	while experience_points >= experience_needed:
		level_up()

func level_up() -> void:
	current_level += 1
	experience_points -= experience_needed
	experience_needed = calculate_experience_needed(current_level)
	
	# Notify that the player leveled up
	print("Leveled up! New level: ", current_level)
	print("Experience needed for next level: ", experience_needed)

	emit_signal("experience_updated")

func calculate_experience_needed(level: int) -> int:
	return int(base_xp * level + log(level + 1) * curve_steepness)

func get_current_level() -> int:
	return current_level

func get_experience_points() -> int:
	return experience_points
