extends Resource

class_name LootTable
# We define loot_table as an array of dictionaries with `item` and `chance` fields
@export var loot_table: Array[Item]:
	set(value):
		loot_table = value
		loot_table.sort_custom(func(a, b): return a.weight > b.weight)

		_calculate_total_weight()

var total_weight: int = 0


func _calculate_total_weight():
	total_weight = 0
	for loot in loot_table:
		total_weight += loot.drop_weight


func get_random_loot() -> Item:
	var picked_weight = randi_range(0, total_weight)

	for loot in loot_table:
		if picked_weight <= picked_weight:
			print("loot picked")
			return loot
		picked_weight -= loot.drop_weight

	return null
