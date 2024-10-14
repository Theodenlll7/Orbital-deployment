class_name Hitbox extends Area2D

@export var damage: int = 10
@export var cast_shape: Shape2D  # This will be the shape for the hitbox
@export var cast_margin: float = 0.1  # A small margin to avoid tunneling issues

@onready var last_position: Vector2 = global_position


func _physics_process(_delta: float) -> void:
	# Perform shape casting from the last position to the current position
	ray_cast_to_current_position()
	# Update last position to the current position
	last_position = global_position


# Function to perform the shape cast from last_position to the current global position
func ray_cast_to_current_position() -> void:
	# Get the space state (physics world)
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsRayQueryParameters2D.create(
		global_position, last_position, collision_mask, [self]
	)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	# Cast the shape from last_position to the current global position
	var result = space_state.intersect_ray(query)

	if result:
		var collider = result["collider"]
		if collider is Hurtbox and not collider.is_invulnerable:
			collider.damage(damage)
			get_parent().queue_free()
