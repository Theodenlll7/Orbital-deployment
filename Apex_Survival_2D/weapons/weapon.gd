extends Node
class_name Weapon

enum AttackMode {
	SINGLE,  ## Attacks ones per button press
	AUTOMATIC,  ## Attacks continulsy with button press
}

@export var attackMode: AttackMode = AttackMode.SINGLE
@export var attackRate: float = 0.2  ## Time between shots in seconds

var canAttack: bool = true
var timer: float = 0


func _process(delta) -> void:
	if !canAttack:
		timer += delta
		if timer >= attackRate:
			canAttack = true
			timer = 0


func attack():
	if canAttack:
		Attack()
		if attackMode == AttackMode.SINGLE:
			canAttack = false


func Attack() -> void:
	pass
