extends Node
class_name Weapon

enum AttackMode {
	SINGLE,  ## Attacks ones per button press
	AUTOMATIC,  ## Attacks continulsy with button press
}

@export var attackMode: AttackMode = AttackMode.SINGLE
@export var attackRate: float = 0.2  ## Time between shots in seconds

var canAttack: bool = true
var cooldown: float = 0


func _process(delta) -> void:
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true
			cooldown = 0

	if Input.is_action_pressed("primary_action"):
		attack()


func attack():
	if canAttack:
		weapon_attack()
		cooldown = attackRate
		if attackMode == AttackMode.SINGLE:
			Input.action_release("primary_action")
			canAttack = false


func weapon_attack() -> void:
	pass
