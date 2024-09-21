extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var dodge_speed: float = 200
@export var dodge_duration: float = 0.4
@export var dodge_cooldown: float = 0.5

@onready var animated_sprite := $AnimatedSprite2D
@onready var camera := $Camera2D
@onready var inventory := $Inventory

@onready var death_screen: DeathScreen = $PlayerHUD/DeathScreen

@export var weapon_orbit_distance: float = 8.0  # Distance from the player at which the weapon orbits

var dodge_timer := -dodge_cooldown
var can_dodge := true
var in_dodge := false

var can_move := true

@onready var weapon_orbit_point := $WeaponOrbitPoint

var held_weapon: Weapon = null

var aim_dir: Vector2 = Vector2()


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		move_player(delta)
		aim()
		if not in_dodge:
			animate()


func _unhandled_input(event):
	if event.is_action_pressed("swap_weapon"):
		inventory.select_next_slot()


func move_player(delta: float) -> void:
	if can_dodge and Input.is_action_just_pressed("dodge"):
		start_dodge()

	if dodge_timer > -dodge_cooldown:
		dodge_timer -= delta
		if dodge_timer <= -dodge_cooldown:
			can_dodge = true

	if dodge_timer > 0:
		in_dodge = true
		velocity = velocity.normalized() * dodge_speed
	else:
		in_dodge = false
		var input_vector = (
			Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		)
		velocity = input_vector * move_speed

	move_and_slide()


func start_dodge() -> void:
	can_dodge = false
	dodge_timer = dodge_duration
	animated_sprite.play("roll_h")


func aim() -> void:
	var orbit_position: Vector2 = weapon_orbit_point.global_position
	var mouse_position: Vector2 = get_global_mouse_position()
	aim_dir = (mouse_position - orbit_position).normalized()

	if held_weapon:
		held_weapon.look_at(mouse_position)

		# Position the weapon at the orbit distance from the player along the direction
		held_weapon.global_position = orbit_position + aim_dir * weapon_orbit_distance

		if mouse_position.x < orbit_position.x:
			held_weapon.scale.y = -abs(held_weapon.scale.y)  # Flip horizontally
		else:
			held_weapon.scale.y = abs(held_weapon.scale.y)  # Ensure no flip

		if mouse_position.y < orbit_position.y:
			held_weapon.z_index = -1  # Render behind the player when aiming above
		else:
			held_weapon.z_index = 1  # Render in front of the player when aiming below


func equip_weapon(weapon: WeaponResource) -> Weapon:
	if held_weapon:
		held_weapon.queue_free()
	held_weapon = Weapon.new(weapon)
	weapon_orbit_point.add_child(held_weapon)
	return held_weapon


func animate() -> void:
	if aim_dir.x < 0:
		animated_sprite.flip_h = true
	elif aim_dir.x > 0:
		animated_sprite.flip_h = false
	if !velocity.is_zero_approx():
		animated_sprite.play("run_h")
	elif !velocity.is_zero_approx():
		animated_sprite.play("run_v_up")
	else:
		animated_sprite.play("idle")


func _on_health_component_health_changed(amount: Variant) -> void:
	if amount < 0:
		camera.screen_shake()


func _on_health_component_died() -> void:
	can_move = false
	animated_sprite.play("die")
	death_screen.fade_in()
