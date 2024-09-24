extends Resource
class_name ExplosiveResource

## Name and explosive value
@export_group("Explosive Details")
@export var item_name: StringName = "Explosive"
## Purchase cost for the explosive
@export var cost: int = 150

## How the explosive looks and sounds
@export_group("Explosive Setup")
@export var texture: Texture
@export var throw_offset: Vector2 = Vector2(0, 0)  # Offset for throwing position
@export var audio_stream_throw: AudioStream
@export var audio_stream_explode: AudioStream

## How the explosive acts
@export_group("Explosive Handle")

## Time between throws (cooldown in seconds)
@export var throw_rate: float = 1.5

@export_subgroup("Explosion Details")
## Damage per explosion, default set to 100
@export var explosion_damage: int = 100

## Radius of the explosion, in pixels (default 200)
@export var explosion_radius: float = 200.0

## Time between throwing and explosion (fuse time)
@export var fuse_time: float = 3.0

## Whether the explosive has a limited quantity
@export var has_explosive_quantity: bool = true

@export_subgroup("Explosive Quantity")
## Number of explosives per inventory (like grenades per stack)
@export var explosive_count: int = 3
## Maximum number of explosives the player can carry
@export var explosive_capacity: int = 5

## Time for reloading or restocking explosives
@export var reload_time: float = 2.0

## The amount of explosives gained from resupply or crates
@export var resupply_value: int = 2

var explosive_action: Callable = _explode


func resupply():
	## Logic for handling resupply
	if has_explosive_quantity:
		explosive_count += resupply_value
		if explosive_count > explosive_capacity:
			explosive_count = explosive_capacity

func _explode(_explosive: Explosive) -> void:
	## This method should be overridden to define explosion behavior
	push_error("The 'explode' is a callable that must be overridden in a subclass")
