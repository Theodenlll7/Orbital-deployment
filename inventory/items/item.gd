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

	# Set the initial position to the node's position
	item.global_position = node.global_position
	node.get_tree().current_scene.add_child(item)

	# Generate a random direction and distance for the drop
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()  # Random horizontal direction, upward
	var distance = randf_range(5, 25)  # Random distance for the item to travel

	# Calculate the target position by moving in the random direction
	var target_position = item.global_position + direction * distance

	# Create a Tween node for animating the drop
	var tween = item.create_tween()

	# Animate the movement to the target position
	tween.tween_property(item, "global_position", target_position, 0.5)

	# Optionally, animate a fall-down effect (simulating gravity)
	#tween.tween_property(item, "global_position", fall_position, 0.3)



func pickup_condition(_player: Player) -> bool:
	return true


func pickup_item(_player: Player) -> void:
	pass
