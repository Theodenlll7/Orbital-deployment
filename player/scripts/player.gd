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
@onready var player_hud: PlayerHUD = $PlayerHUD

@export var weapon_orbit_distance: float = 8.0  # Distance from the player at which the weapon orbits
@export var weapon_orbit_point: Marker2D = null

@onready var health_component: HealthComponent = $HealthComponent

var dodge_timer := -dodge_cooldown
var can_dodge := true
var in_dodge := false
var player_dead := false

var can_move := true

var held_weapon: PlayerWeapon = null
var held_explosive: Explosive = null

var aim_dir: Vector2 = Vector2()


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	_bind_inventory()
	health_component.max_health *= PlayerSkillsManager.get_healt_scaler()
	health_component.current_health *= PlayerSkillsManager.get_healt_scaler()


func _bind_inventory() -> void:
	inventory.actor = self
	inventory.new_weapon.connect(player_hud.equip_weapon)
	inventory.weapon_swap.connect(equip_weapon)
	inventory.money_changed.connect(player_hud.update_money_display)
	player_hud.update_money_display(inventory.money)
	
	inventory.new_explosive.connect(player_hud.equip_explosive)
	inventory.new_explosive.connect(equip_explosive)
	
	inventory.setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_move:
		move_player(delta)
		aim()
		if not in_dodge:
			animate()


func _physics_process(_delta: float) -> void:
	if can_move:
		move_and_slide()


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


func equip_weapon(index: int, weapon: WeaponResource) -> Weapon:
	if held_weapon:
		held_weapon.queue_free()
	held_weapon = PlayerWeapon.new(weapon)
	weapon_orbit_point.add_child(held_weapon)
	player_hud.select_weapon_slot(index)
	player_hud.ammo_indicator.equip_weapon(weapon)
	return held_weapon


func equip_explosive(explosive: ExplosiveResource) -> Explosive:
	if held_explosive:
		held_explosive.queue_free()
	held_explosive = Explosive.new(explosive)
	held_explosive.scale = Vector2(0.01, 0.01)
	weapon_orbit_point.add_child(held_explosive)
	return held_explosive


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
	print()
	if !player_dead:
		flash_red(animated_sprite)
	if amount < 0:
		camera.screen_shake()


func flash_red(sprite: AnimatedSprite2D) -> void:
	var tween = create_tween()
	var time = 0.05
	tween.tween_property(sprite, "modulate", Color(0.8, 0.2, 0.2), time)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), time)


func _on_health_component_died() -> void:
	player_dead = true
	can_move = false
	held_weapon.queue_free()
	animated_sprite.play("die")
	death_screen.fade_in()
