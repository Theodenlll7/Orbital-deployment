extends Resource
class_name WeaponResource

## Name and weapon value
@export_group("Weapon Details")
@export var weapon_name: StringName = "Weapon"
##Purchase cost
@export var weapon_cost: int = 100

## How the weapon looks and sounds
@export_group("Weapon Setup")
@export var texture: Texture
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
@export var attack_rate: float = 0.2

@export_subgroup("Amunition")
@export var has_magazine: bool = true

##Damage per bullet, standard damage set to 10
@export var bullet_damage: int = 10

##Speed of bullets, standard speed set to 500.0
@export var bullet_speed: float = 500.0

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

var attack: Callable = _attack


func ammo_create_picked_up():
	if has_ammo:
		ammo += ammo_crate_value
		if ammo > ammo_cap:
			ammo = ammo_cap


func _attack(_weapon: Weapon) -> void:
	push_error("The 'attack' is a callable that must be overridden in a subclass")
