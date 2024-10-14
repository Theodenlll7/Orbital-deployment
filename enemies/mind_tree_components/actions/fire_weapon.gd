class_name AttackWithWeapon extends MTAction

@export var weapon: MobWeapon


func tick(_blackboard: Blackboard) -> int:
	if weapon.can_attack:
		weapon.attack()
		return SUCCESS

	return FAILURE
