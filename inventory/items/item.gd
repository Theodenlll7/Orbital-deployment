extends Resource
class_name Item

enum DropType { MAGNETIC, INTERACTABLE }  # Fixed the spelling and enum declaration
@export_group("Item properties")

## How the item is represented on the ground
@export var drop_type = DropType.MAGNETIC
@export var texture: Texture2D = null
@export var drop_weight: int = 100


func drop_on_ground(node: Node2D):
	var item: Node2D
	match drop_type:
		DropType.MAGNETIC:
			item = MagneticItem.new(self)
		DropType.INTERACTABLE:
			pass

	item.global_position = node.global_position
	print("Item drop ", item)
	node.get_tree().current_scene.add_child(item)


func pickup_condition(_player: Player) -> bool:
	return true


func pickup_item(_player: Player) -> void:
	pass
