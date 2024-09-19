extends RigidBody2D
class_name MagneticItem

# Variables to adjust
var player: Node2D = null
var speed: float = 100
var pick_up_distance: float = 15


func _physics_process(_delta: float) -> void:
	if player:
		# Calculate the distance between the item and the player
		var distance_to_player = position.distance_to(player.position)

		# Normalize direction vector towards the player
		var direction = (player.position - position).normalized()
		# Apply force proportional to the inverse of the distance
		var force_multiplier = clamp(1000 / distance_to_player, 1, 15)

		apply_force(direction * speed * force_multiplier)
		# Check if close enough to pick up
		if distance_to_player < pick_up_distance:
			pick_up_item()

		# Start dampening velocity as we get close to the player to prevent circling
		if distance_to_player < 50:
			linear_velocity = lerp(linear_velocity, Vector2.ZERO, 0.1)


func pick_up_item():
	print("Item picked up!")
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if player == null and body.is_in_group("players"):
		player = body
