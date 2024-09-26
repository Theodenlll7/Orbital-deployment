class_name MobWeapon extends Weapon

@export var accuracy: float = 0.2  # 1.0 = perfect accuracy, lower values = more spread
@export var weapon_orbit_distance: float = 8.0  # Distance from the orbit point at which the weapon orbits
@export var position_lerp_speed: float = 20

var can_attack: bool = true  # Used to manage cooldowns

@onready var target = null

@onready var cooldown_timer = Timer.new()
@onready var orbit_position: Vector2 = $WeaponOrbitPoint.position

var attack_enabled := false


# Ready function
func _ready():
	assert(orbit_position, "Mob Weapon has no orbit point")
	add_child(cooldown_timer)
	cooldown_timer.wait_time = weapon_resource.attack_cooldown
	cooldown_timer.timeout.connect(_on_cooldown_timeout)


# Function to set the target (player)
func set_target(new_target):
	target = new_target


func start_attacking():
	attack_enabled = true


func stop_attacking():
	attack_enabled = false


func _process(delta: float) -> void:
	aim(delta)
	attack()


func aim(delta: float) -> void:
	if !target:
		return

	var aim_dir: Vector2 = aim_direction()

	# Get the current aim direction (from the weapon's current position)
	var current_dir = Vector2.RIGHT.rotated(global_rotation)

	# Lerp between current direction and the target aim direction (smoothly rotate around the orbit point)
	var interpolated_dir = current_dir.lerp(aim_dir, position_lerp_speed * delta).normalized()

	# Keep the weapon at a constant distance from the orbit point (circular orbit)
	position = orbit_position + interpolated_dir * weapon_orbit_distance

	# Directly set the rotation based on the interpolated direction
	rotation = interpolated_dir.angle()

	# Flip the weapon horizontally based on the direction it's aiming
	if interpolated_dir.x < 0:
		scale.y = -abs(scale.y)  # Flip horizontally when aiming left
	else:
		scale.y = abs(scale.y)  # Ensure no flip when aiming right

	# Adjust z-index to render the weapon behind or in front of the player/mob
	if interpolated_dir.y < 0:
		z_index = -1  # Render behind the player when aiming upwards
	else:
		z_index = 1  # Render in front of the player when aiming downwards


# Function to handle aiming at the player with accuracy tweaks
func aim_direction() -> Vector2:
	var direction = (target.global_position - to_global(orbit_position)).normalized()

	# Apply accuracy offset (randomly offset direction based on accuracy)
	var inaccuracy_angle = (1.0 - accuracy) * randf_range(-1, 1)
	direction = direction.rotated(inaccuracy_angle)

	return direction


# Function to trigger an attack
func attack():
	if !target or !can_attack or !attack_enabled:
		return

	weapon_resource.attack(self)

	can_attack = false
	cooldown_timer.start()


# Cooldown timer finished
func _on_cooldown_timeout():
	can_attack = true
