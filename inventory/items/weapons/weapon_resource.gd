extends Resource
class_name WeaponResource

@export_group("Store Details")
@export var weapon_name: StringName = "Weapon"
##Purchase cost
@export var weapon_cost: int = 100

@export_group("Weapon Setup")
@export var texture: Texture
@export var muzzel_offset: Vector2 = Vector2(0, 0)

enum AttackMode {
	SINGLE,  ## Attacks ones per button press
	AUTOMATIC,  ## Attacks continulsy while button is pressed
}

@export_group("Weapon Handle")
@export var attack_mode: AttackMode = AttackMode.SINGLE
## Time between shots in seconds
@export var attack_rate: float = 0.2
##How many bullets can be fired before reloding
@export var magasine_size: int = 10

var attack: Callable = _attack


func _attack(_weapon: Weapon) -> void:
	push_error("The 'attack' is a callable that must be overridden in a subclass")
