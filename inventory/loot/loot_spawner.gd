extends Node2D

@export var loot_table: LootTable
@export_range(0, 1) var item_spawn_chanse: float = 1
@export_range(1, 20) var spawn_attempts: int = 1


func spawn_loot() -> void:
	for i in range(spawn_attempts):
		if item_spawn_chanse != 1:
			if randf_range(0, 1) >= item_spawn_chanse:
				continue
		var item := loot_table.get_random_loot()
		item.drop_on_ground(global_position)
