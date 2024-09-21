extends Resource

class_name LootTable
# We define loot as an array of dictionaries with `item` and `chance` fields
@export var loot: Dictionary


func get_random_loot():
	var total_chance = 0
	for entry in loot:
		total_chance += entry["chance"]

	var random_value = randf() * total_chance
	var accumulated_chance = 0

	for entry in loot:
		accumulated_chance += entry["chance"]
		if random_value <= accumulated_chance:
			return entry["item"]

	return null  # If nothing matches, return null
