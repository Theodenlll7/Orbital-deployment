extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var dodge_speed: float = 200
@export var dodge_duration: float = 0.4
@export var dodge_cooldown: float = 0.5

@onready var animated_sprite := $AnimatedSprite2D
@onready var camera := $Camera2D
@onready var inventory := $Inventory
@onready var hurtbox := $Hurtbox

@onready var death_screen: DeathScreen = $PlayerHUD/DeathScreen
@onready var player_hud: PlayerHUD = $PlayerHUD

@export var weapon_orbit_distance: float = 8.0  # Distance from the player at which the weapon orbits
@export var weapon_orbit_point: Marker2D = null

@onready var health_component: HealthComponent = $HealthComponent

var dodge_timer: Timer
var dodge_cooldown_timer: Timer
var can_dodge := true
var in_dodge := false
var player_dead := false

var can_move := true

var held_weapon: PlayerWeapon = null
var held_explosive: HeldExplosive = null

var aim_dir: Vector2 = Vector2()


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	_bind_inventory()
	health_component.max_health = int(
		health_component.current_health * PlayerSkillsManager.healt_scaler
	)
	health_component.current_health = int(
		health_component.current_health * PlayerSkillsManager.healt_scaler
	)
	_setup_health_regen()

	dodge_timer = Timer.new()
	add_child(dodge_timer)
	dodge_timer.wait_time = dodge_duration
	dodge_timer.one_shot = true
	dodge_timer.timeout.connect(_on_dodge_ended)

	dodge_cooldown_timer = Timer.new()
	add_child(dodge_cooldown_timer)
	dodge_cooldown_timer.wait_time = dodge_cooldown
	dodge_cooldown_timer.one_shot = true
	dodge_cooldown_timer.timeout.connect(func(): can_dodge = true)


func _setup_health_regen() -> void:
	if PlayerSkillsManager.health_regeneration_scaler != 0:
		var timer = Timer.new()
		timer.wait_time = 5
		timer.one_shot = false
		timer.autostart = true
		timer.timeout.connect(_regen)
		add_child(timer)


func _regen():
	if !player_dead:
		health_component.heal(int(PlayerSkillsManager.health_regeneration_scaler))


func _bind_inventory() -> void:
	inventory.actor = self
	inventory.new_weapon.connect(player_hud.equip_weapon)
	inventory.weapon_swap.connect(equip_weapon)
	inventory.money_changed.connect(player_hud.update_money_display)
	player_hud.update_money_display(inventory.money)

	inventory.new_explosive.connect(player_hud.equip_explosive)
	inventory.new_explosive.connect(equip_explosive)
	inventory.money += PlayerSkillsManager.start_money_increase
	inventory.setup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if can_move:
		move_player()
		aim()
		if not in_dodge:
			animate()


func _physics_process(_delta: float) -> void:
	if can_move:
		move_and_slide()


func _unhandled_input(event):
	if player_dead:
		return

	if event.is_action_pressed("swap_weapon"):
		inventory.select_next_slot()

	if can_dodge and event.is_action_pressed("dodge"):
		start_dodge()


func move_player() -> void:
	if in_dodge:
		velocity = velocity.normalized() * dodge_speed
	else:
		var input_vector = (
			Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		)
		velocity = input_vector * move_speed


func start_dodge() -> void:
	can_dodge = false
	in_dodge = true
	dodge_timer.start()
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)
	animated_sprite.play("roll_h")
	hurtbox.is_invulnerable = true
	play_dodge_sound()

func play_dodge_sound() -> void:
	var random_number = randi_range(1, 3)
	var sound: AudioStream = load("res://player/assets/sounds/dodge_" + str(random_number) + ".ogg")
	var player = AudioStreamPlayer.new()
	
	player.stream = sound
	player.bus = "UI"
	
	add_child(player)
	
	player.play()
	player.connect("finished", Callable(player, "queue_free"))

func _on_dodge_ended() -> void:
	in_dodge = false
	hurtbox.is_invulnerable = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(2, true)
	dodge_cooldown_timer.start()


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


func equip_explosive(explosive: ExplosiveResource) -> HeldExplosive:
	if held_explosive:
		held_explosive.queue_free()
		held_explosive = null
	if explosive:
		held_explosive = HeldExplosive.new(explosive)
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
	if amount > 0:
		return
	if !player_dead:
		flash_red(animated_sprite)
		camera.screen_shake()
		TooltipHud.show_dodge_tip()

func flash_red(sprite: AnimatedSprite2D) -> void:
	var tween = create_tween()
	var time = 0.05
	tween.tween_property(sprite, "modulate", Color(0.8, 0.2, 0.2), time)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), time)


func _on_health_component_died() -> void:
	player_dead = true
	set_process(false)
	set_physics_process(false)
	can_move = false
	held_weapon.queue_free()
	animated_sprite.play("die")
	death_screen.fade_in()
