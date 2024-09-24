extends RigidBody2D
class_name Grenade_2D

@export var throw_speed: float = 600.0
@export var explosion_damage: int = 100
@export var explosion_radius: float = 200.0
@export var fuse_time: float = 3.0

var direction: Vector2
var explosion_area: Area2D

func _ready() -> void:
	# Apply velocity in the throw direction
	linear_velocity = direction * throw_speed
	
	# Create an Area2D for explosion detection
	explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.set_radius(explosion_radius)
	explosion_area.add_child(collision_shape)
	explosion_area.monitorable = true
	explosion_area.monitoring = false  # Turn it on only at explosion time
	add_child(explosion_area)

	# Start the fuse countdown
	await get_tree().create_timer(fuse_time).timeout
	_explode()

func _explode() -> void:
	# Activate area monitoring to detect overlapping bodies
	explosion_area.monitoring = true
	
	# Get all bodies in the explosion radius
	var overlapping_bodies = explosion_area.get_overlapping_bodies()

	for body in overlapping_bodies:
		if body.has_method("take_damage"):
			body.take_damage(explosion_damage)

	# Optionally add explosion effects (e.g., particles or sound)
	
	queue_free()  # Remove the grenade after explosion
