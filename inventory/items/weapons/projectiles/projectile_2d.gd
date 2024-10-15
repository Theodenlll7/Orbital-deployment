extends RigidBody2D
class_name Projectile2D

@export var speed: float = 2000.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2

@onready var last_position : Vector2 = global_position

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	body_entered.connect(_on_body_entered)

	if $Hitbox:
		$Hitbox.damage = damage
		$Hitbox.hit.connect(_on_body_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()

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
			queue_free()

func _on_body_entered(_body: Node) -> void:
	queue_free()
