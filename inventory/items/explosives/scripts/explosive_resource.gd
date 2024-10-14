extends Item
class_name ExplosiveResource

## Name and explosive value
@export_group("Explosive Details")
@export var item_name: StringName = "Explosive"
@export var cost: int = 150

## How the explosive looks and sounds
@export_group("Explosive Setup")
@export var throw_offset: Vector2 = Vector2(0, 0)  
@export var audio_stream_throw: AudioStream
@export var audio_stream_explode: AudioStream

## How the explosive acts
@export_group("Explosive throw")
@export var throw_speed: float = 2.0
@export var muzzel_offset: Vector2 = Vector2(0, 0)
@export var grenade_weight: float = 0.2

@export_subgroup("Explosion Details")
@export var explosion_damage: int = 100
@export var explosion_radius: float = 200.0
@export var fuse_time: float = 3.0

## Whether the explosive has a limited quantity
@export var has_explosive_quantity: bool = true

@export_subgroup("Explosive Quantity")

@export var explosive_count: int = 3

var throw_action: Callable = _throw

@export var grenade_scene: PackedScene

@export_subgroup("accessibility")
@export var weapon_accessibility_wave = 0

func _throw(_explosive: Explosive) -> void:
	## This method should be overridden to define explosion behavior
	push_error("The 'explode' is a callable that must be overridden in a subclass")
