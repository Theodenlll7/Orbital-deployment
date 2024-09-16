extends Node
class_name Weapon

@export var weapon_texture_icon: Texture  # Texture associated with the weapon

var weapon_data : WeaponData

func _init(data : WeaponData):
	weapon_data = data

func _ready() -> void:
	var marker = Marker2D.new()
	marker.name = "muzzel"
	marker.position = weapon_data.muzzel_offset
	add_child(marker)

## Time between shots in seconds
@export var attackRate: float = 0.2

var canAttack: bool = true
var cooldown: float = 0

func _process(delta) -> void:
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true


func _unhandled_input(event):
	if (
		canAttack
		and (
			(weapon_data.attack_mode == WeaponData.AttackMode.AUTOMATIC and Input.is_action_pressed("primary_action"))
			or (weapon_data.attack_mode == WeaponData.AttackMode.SINGLE and Input.is_action_just_pressed("primary_action"))
		)
	):
		attack()
		cooldown = weapon_data.attack_rate
		canAttack = false


func attack() -> void:
	push_error("The 'attack' function must be overridden in a subclass")
