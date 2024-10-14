extends Node2D
class_name Weapon

@warning_ignore("unused_signal")

@export var weapon_resource: WeaponResource = null

var audio_player: AudioStreamPlayer

var sprite: Sprite2D

@onready var cooldown_timer = Timer.new()


func _init(data: WeaponResource = null):
	if !data:
		return
	weapon_resource = data


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.scale = Vector2(0.8, 0.8)
	sprite.texture = weapon_resource.texture
	add_child(sprite)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = weapon_resource.audio_steam
	add_child(audio_player)

	add_child(cooldown_timer)
	cooldown_timer.wait_time = weapon_resource.attack_cooldown
	cooldown_timer.timeout.connect(_on_cooldown_timeout)


var can_attack: bool = true
var reloading: bool = false
var reload_time = 0


func attack() -> void:
	weapon_resource.attack(self)
	audio_player.play()
	cooldown_timer.start()
	can_attack = false


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

	weapon_resource.ammo_changed.emit(weapon_resource.ammo)
	weapon_resource.magazine_changed.emit(weapon_resource.ammo_in_magazine)


# Cooldown timer finished
func _on_cooldown_timeout():
	can_attack = true
