extends Node2D
class_name Weapon

signal weapon_fired(new_magazine_amount: int)
signal weapon_reloded(new_magazine_amount: int, new_ammo_amount: int)

var weapon_resource: WeaponResource

var audio_player: AudioStreamPlayer

var sprite: Sprite2D


func _init(data: WeaponResource):
	weapon_resource = data


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.scale = Vector2(0.8, 0.8)
	sprite.texture = weapon_resource.texture
	add_child(sprite)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = weapon_resource.audio_steam
	add_child(audio_player)


## Time between shots in seconds
@export var attackRate: float = 0.2

var canAttack: bool = true
var cooldown: float = 0
var reloading: bool = false
var reload_time = 0


func _process(delta) -> void:
	if weapon_resource.has_magazine:
		if !reloading and Input.is_action_just_pressed("reload"):
			reload()

	if !canAttack:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true

	elif !reloading and attack_pressed():
		if weapon_resource.has_magazine:
			if weapon_resource.ammo_in_magazine > 0:
				weapon_resource.ammo_in_magazine -= 1
				weapon_fired.emit(weapon_resource.ammo_in_magazine)
				attack()
			elif Input.is_action_just_pressed("primary_action"):
				reload()
		elif weapon_resource.has_ammo and weapon_resource.ammo > 0:
			weapon_resource.ammo -= 1
			weapon_fired.emit(weapon_resource.ammo)
			attack()
		else:
			attack()

func get_bullet_damage() -> int:
	return weapon_resource.bullet_damage

func get_bullet_speed() -> float:
	return weapon_resource.bullet_speed
	
func get_bullet_lifetime() -> float:
	return weapon_resource.bullet_lifetime
	
func get_bullet_spread() -> float:
	return weapon_resource.bullet_spread
	
func get_bullets_per_shot() -> int:
	return weapon_resource.bullets_per_shot

func attack_pressed() -> bool:
	return (
		(
			weapon_resource.attack_mode == WeaponResource.AttackMode.AUTOMATIC
			and Input.is_action_pressed("primary_action")
		)
		or (
			weapon_resource.attack_mode == WeaponResource.AttackMode.SINGLE
			and Input.is_action_just_pressed("primary_action")
		)
	)


func attack() -> void:
	weapon_resource.attack.call(self)
	audio_player.play()
	cooldown = weapon_resource.attack_rate
	canAttack = false


func reload() -> void:
	if (
		weapon_resource.ammo_in_magazine >= weapon_resource.magazine_size
		or weapon_resource.ammo <= 0
	):
		return

	reload_time = weapon_resource.reload_time
	reloading = true

	var tween = create_tween()

	tween.tween_property(sprite, "rotation_degrees", sprite.rotation_degrees + 360, reload_time)

	tween.finished.connect(_on_reload_complete)

	tween.play()


func _on_reload_complete() -> void:
	sprite.rotation_degrees = 0
	reloading = false
	var missing_ammo_in_magazine = weapon_resource.magazine_size - weapon_resource.ammo_in_magazine
	if missing_ammo_in_magazine > 0:
		if weapon_resource.ammo >= missing_ammo_in_magazine:
			# If enough ammo is available to fully reload
			weapon_resource.ammo_in_magazine = weapon_resource.magazine_size
			weapon_resource.ammo -= missing_ammo_in_magazine

		else:
			# Partially reload if there's not enough ammo
			weapon_resource.ammo_in_magazine += weapon_resource.ammo
			weapon_resource.ammo = 0

	weapon_reloded.emit(weapon_resource.ammo_in_magazine, weapon_resource.ammo)
