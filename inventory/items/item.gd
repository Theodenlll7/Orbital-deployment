extends Resource
class_name Item

## How the item is represented on the ground
@export var ground_item: PackedScene = null


func drop_on_ground(position: Vector2):
	assert(ground_item)

	assert(ground_item.is_class("MagneticItem"))

	var spawned_item = ground_item.instantiate() as Area2D
	spawned_item.global_position = position
