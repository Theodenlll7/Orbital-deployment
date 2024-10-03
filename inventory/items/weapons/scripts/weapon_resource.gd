extends Item
class_name WeaponResource

signal ammo_changed(new_ammo_count: int)
@warning_ignore("unused_signal")
signal magazine_changed(new_magazine_count: int)

## Name and weapon value
@export_group("Weapon Details")
@export var item_name: StringName = "Weapon"
##Purchase cost
@export var cost: int = 100

## How the weapon looks and sounds
@export_group("Weapon Setup")
@export var muzzel_offset: Vector2 = Vector2(0, 0)
@export var audio_steam: AudioStream

## How the weapon acts
@export_group("Weapon Handle")
enum AttackMode {
	SINGLE,  ## Attacks ones per button press
	AUTOMATIC,  ## Attacks continulsy while button is pressed
}
@export var attack_mode: AttackMode = AttackMode.SINGLE
## Time between shots in seconds
@export var attack_cooldown: float = 0.2

@export_subgroup("Amunition")
@export var has_magazine: bool = true

##Damage per bullet, standard damage set to 10
@export var bullet_damage: int = 10

##Speed of bullets, standard speed set to 500.0
@export var bullet_speed: float = 500.0

## Spread of a bullet (deg), normaly set to 0.0
@export var bullet_spread: float = 0.0

##Lifetime of a bullet, standard set to 2.0
@export var bullet_lifetime: float = 2.0

##Number of bullets per singel shot
@export var bullets_per_shot: int = 1

var ammo_in_magazine: int
##How many bullets can be fired before reloding
@export var magazine_size: int = 10:
	set(value):
		ammo_in_magazine = value
		magazine_size = value

## The time it takes to reload (in seconds)
@export var reload_time: float = 0.5

@export var has_ammo: bool = true
##Current amount of amuntion
@export var ammo: int = 50
##Maximum ammo cary capasity set to 0 to disable
@export var ammo_cap: int = 200

##Amount of ammo recived from ammo crate
@export var ammo_crate_value: int = 50


func ammo_create_picked_up():
	if has_ammo:
		ammo += ammo_crate_value
		if ammo > ammo_cap:
			ammo = ammo_cap
	ammo_changed.emit(ammo)


func attack(_weapon: Weapon) -> void:
	push_error("The 'attack' is a callable that must be overridden in a subclass")
