class_name MobWeapon extends Weapon

@export var accuracy: float = 0.8  # 1.0 = perfect accuracy, lower values = more spread
@export var weapon_orbit_distance: float = 8.0  # Distance from the orbit point at which the weapon orbits
@export var position_lerp_speed: float = 1

@onready var target = null

@onready var orbit_position: Vector2 = $WeaponOrbitPoint.position

var attack_enabled := false

# Ready function
func _ready():
	super()
	assert($WeaponOrbitPoint, "Mob Weapon has no orbit point")
	var hp = get_parent().get_node_or_null("HealthComponent") as HealthComponent
	hp.died.connect(func(): stop_attacking())


# Function to set the target (player)
func set_target(new_target):
	target = new_target


func start_attacking():
	attack_enabled = true


func stop_attacking():
	attack_enabled = false
	position = orbit_position
	rotation = 0
	z_index = 1
	scale.y = abs(scale.y)


func _process(_delta: float) -> void:
	if attack_enabled:
		aim(target)
	if target and can_attack and attack_enabled:
		attack()


func aim(the_target: Node2D) -> void:
	if !the_target:
		return
	var aim_dir = (the_target.global_position - to_global(orbit_position)).normalized()
	# Keep the weapon at a constant distance from the orbit point (circular orbit)
	position = orbit_position + aim_dir * weapon_orbit_distance

	# Directly set the rotation based on the interpolated direction
	rotation = aim_dir.angle()

	# Flip the weapon horizontally based on the direction it's aiming
	if aim_dir.x < 0:
		scale.y = -abs(scale.y)  # Flip horizontally when aiming left
	else:
		scale.y = abs(scale.y)  # Ensure no flip when aiming right

	# Adjust z-index to render the weapon behind or in front of the player/mob
	if aim_dir.y < 0:
		z_index = -1  # Render behind the player when aiming upwards
	else:
		z_index = 1  # Render in front of the player when aiming downwards
