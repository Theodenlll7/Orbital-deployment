extends Node
class_name Weapon

var weapon_name: String = ""
var weapon_cost: int = 0

func _init(
		new_weapon_name: String = "", 
		new_weapon_cost: int = 0, 
		new_attack_mode: AttackMode = AttackMode.SINGLE, 
		new_attack_rate: float = 0.2
	) -> void:
	weapon_name = new_weapon_name
	weapon_cost = new_weapon_cost
	attackMode = new_attack_mode
	attackRate = new_attack_rate
	
enum AttackMode {
	SINGLE,  ## Attacks ones per button press
	AUTOMATIC,  ## Attacks continulsy while button is pressed
}

@export var attackMode: AttackMode = AttackMode.SINGLE

## Time between shots in seconds
@export var attackRate: float = 0.2

var canAttack: bool = true
var cooldown: float = 0


func _process(delta) -> void:
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true


func _input(event):
	if (
		canAttack
		and (
			(attackMode == AttackMode.AUTOMATIC and Input.is_action_pressed("primary_action"))
			or (attackMode == AttackMode.SINGLE and Input.is_action_just_pressed("primary_action"))
		)
	):
		attack()
		cooldown = attackRate
		canAttack = false


func attack() -> void:
	push_error("The 'attack' function must be overridden in a subclass")
