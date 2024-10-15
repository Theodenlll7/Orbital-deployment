extends Item
class_name ExplosiveResource

## Name and explosive value
@export_group("Explosive Details")
@export var item_name: StringName = "Explosive"
@export var cost: int = 150

## How the explosive looks and sounds
@export_group("Explosive Setup")
@export var audio_stream_throw: AudioStream
@export var audio_stream_explode: AudioStream

## How the explosive acts
@export_group("Explosive throw")
@export var throw_speed: float = 2.0
@export var throw_cooldown: float = 0.5
@export var grenade_weight: float = 0.2

@export_subgroup("Explosion Details")
@export var explosion_damage: int = 100
@export var explosion_radius: float = 200.0
@export var exposion_collision_mask : int = 129
@export var fuse_time: float = 3.0

## Whether the explosive has a limited quantity
@export var has_explosive_quantity: bool = true

@export_subgroup("Explosive Quantity")

@export var explosive_count: int = 3

@export_subgroup("accessibility")
@export var weapon_accessibility_player_level = 0

signal explosive_thrown(explosive : ExplosiveResource)

func throw(explosive: HeldExplosive) -> void:
	explosive_count -= 1
	explosive_thrown.emit(self)
	_throw(explosive)

func _throw(_explosive: HeldExplosive) -> void:
	## This method should be overridden to define explosion behavior
	push_error("The 'explode' is a callable that must be overridden in a subclass")
