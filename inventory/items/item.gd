extends Resource
class_name Item

## How the item is represented on the ground
@export var ground_item: PackedScene = null
@export var weight: int = 100


func drop_on_ground(position: Vector2):
	if ground_item:
		var spawned_item = ground_item.instantiate() as Area2D
		spawned_item.global_position = position
