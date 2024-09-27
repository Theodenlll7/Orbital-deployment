class_name SlowAreaEffect2D extends AreaEffect

@export var drag_factor: float = 0.5  # The factor to continuously slow down the character's speed (less than 1 for drag)
@export var min_speed: float = 10  # Minimum speed to prevent character from stopping completely


func _validate_node(node: Node):
	return node as CharacterBody2D


func _apply_area_effect(_delta: float):
	for target in targets_in_area:
		var cb = target as CharacterBody2D
		if cb:
			cb.velocity *= drag_factor

			# Ensure the character doesn't slow down below the minimum speed
			if cb.velocity.length() < min_speed:
				cb.velocity = cb.velocity.normalized() * min_speed
